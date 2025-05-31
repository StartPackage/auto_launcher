import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

String getPackageVersion() {
  try {
    final packageConfigPath = p.join('.dart_tool', 'package_config.json');
    final packageConfigFile = File(packageConfigPath);
    if (!packageConfigFile.existsSync()) {
      return 'Unknown';
    }

    final configJson = jsonDecode(packageConfigFile.readAsStringSync());
    final packages = configJson['packages'] as List<dynamic>;

    final autoLauncher = packages.firstWhere(
      (pkg) => pkg['name'] == 'auto_launcher',
      orElse: () {
        return null;
      },
    );

    if (autoLauncher == null) return 'Unknown';

    final rootUri = autoLauncher['rootUri'] as String;

    final pubspecPath = Uri.parse(rootUri).isAbsolute
        ? p.join(Uri.parse(rootUri).toFilePath(), 'pubspec.yaml')
        : p.normalize(p.join(Directory.current.path, rootUri, 'pubspec.yaml'));

    final pubspecFile = File(pubspecPath);
    if (!pubspecFile.existsSync()) {
      return 'Unknown';
    }

    final content = pubspecFile.readAsStringSync();
    final yaml = loadYaml(content);
    final version = yaml['version']?.toString() ?? 'Unknown';
    return version;
  } catch (e) {
    return 'Unknown';
  }
}
