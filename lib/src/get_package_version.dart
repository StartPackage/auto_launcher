import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

String getPackageVersion() {
  try {
    final packageConfigFile = File(p.join(Directory.current.path, '.dart_tool/package_config.json'));
    if (!packageConfigFile.existsSync()) return 'Unknown';

    final configJson = jsonDecode(packageConfigFile.readAsStringSync());
    final packages = configJson['packages'] as List;

    final autoLauncherPackage = packages.firstWhere(
      (p) => p['name'] == 'auto_launcher',
      orElse: () => null,
    );

    if (autoLauncherPackage == null) return 'Unknown';

    final rootUri = autoLauncherPackage['rootUri'] as String;
    final pathToPubspec = p.join(Directory.current.path, rootUri, 'pubspec.yaml');
    final pubspec = File(pathToPubspec);
    if (!pubspec.existsSync()) return 'Unknown';

    final content = pubspec.readAsStringSync();
    final doc = loadYaml(content);
    return doc['version'] ?? 'Unknown';
  } catch (_) {
    return 'Unknown';
  }
}
