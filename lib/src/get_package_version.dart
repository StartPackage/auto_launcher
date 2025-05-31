import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

String getPackageVersion() {
  final pubspec = File(p.join(Directory.current.path, 'pubspec.yaml'));
  if (!pubspec.existsSync()) return 'Unknown';

  final content = pubspec.readAsStringSync();
  final doc = loadYaml(content);
  return doc['version'] ?? 'Unknown';
}
