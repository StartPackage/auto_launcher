import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

String getPackageVersion() {
  try {
    final packageConfigPath = p.join('.dart_tool', 'package_config.json');
    final packageConfigFile = File(packageConfigPath);
    if (!packageConfigFile.existsSync()) {
      print('[DEBUG] package_config.json not found at $packageConfigPath');
      return 'Unknown';
    }

    final configJson = jsonDecode(packageConfigFile.readAsStringSync());
    final packages = configJson['packages'] as List<dynamic>;

    final autoLauncher = packages.firstWhere(
      (pkg) => pkg['name'] == 'auto_launcher',
      orElse: () {
        print('[DEBUG] auto_launcher not found in package_config.json');
        return null;
      },
    );

    if (autoLauncher == null) return 'Unknown';

    final rootUri = autoLauncher['rootUri'] as String;
    print('[DEBUG] Found rootUri: $rootUri');

    final pubspecPath = Uri.parse(rootUri).isAbsolute
        ? p.join(Uri.parse(rootUri).toFilePath(), 'pubspec.yaml')
        : p.normalize(p.join(Directory.current.path, rootUri, 'pubspec.yaml'));

    print('[DEBUG] Resolved pubspec path: $pubspecPath');

    final pubspecFile = File(pubspecPath);
    if (!pubspecFile.existsSync()) {
      print('[DEBUG] pubspec.yaml does not exist at $pubspecPath');
      return 'Unknown';
    }

    final content = pubspecFile.readAsStringSync();
    final yaml = loadYaml(content);
    final version = yaml['version']?.toString() ?? 'Unknown';
    print('[DEBUG] Parsed version: $version');
    return version;
  } catch (e) {
    print('[DEBUG] Exception in getPackageVersion: $e');
    return 'Unknown';
  }
}
