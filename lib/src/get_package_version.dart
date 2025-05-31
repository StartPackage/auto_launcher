import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

String getPackageVersion() {
  try {
    final configFile = File(p.join('.dart_tool', 'package_config.json'));
    if (!configFile.existsSync()) return 'Unknown';

    final configJson = jsonDecode(configFile.readAsStringSync());
    final packages = configJson['packages'] as List<dynamic>;

    final thisPackage = packages.firstWhere(
      (pkg) => pkg['name'] == 'auto_launcher',
      orElse: () => null,
    );

    if (thisPackage == null) return 'Unknown';

    String rootUri = thisPackage['rootUri'] as String;
    String pubspecPath;

    if (Uri.parse(rootUri).isAbsolute) {
      // Absolute URI (rare)
      pubspecPath = p.join(Uri.parse(rootUri).toFilePath(), 'pubspec.yaml');
    } else {
      // Relative URI
      pubspecPath = p.join(Directory.current.path, rootUri, 'pubspec.yaml');
    }

    final pubspecFile = File(p.normalize(pubspecPath));
    if (!pubspecFile.existsSync()) return 'Unknown';

    final content = pubspecFile.readAsStringSync();
    final yaml = loadYaml(content);
    return yaml['version']?.toString() ?? 'Unknown';
  } catch (e) {
    return 'Unknown';
  }
}
