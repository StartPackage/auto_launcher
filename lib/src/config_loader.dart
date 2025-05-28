import 'dart:io';
import 'package:yaml/yaml.dart';

Map<String, dynamic> loadAutoLauncherConfig() {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('Error: pubspec.yaml not found!');
    exit(1);
  }

  final content = pubspecFile.readAsStringSync();
  final yamlMap = loadYaml(content);

  final launcher = yamlMap['auto_launcher'];
  if (launcher == null) {
    print('Error: auto_launcher section not found in pubspec.yaml');
    exit(1);
  }

  return Map<String, dynamic>.from(launcher);
}
