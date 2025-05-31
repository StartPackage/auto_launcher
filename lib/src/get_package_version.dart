import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

String getPackageVersion() {
  // Locate the package's own pubspec.yaml even when used as a dependency
  final packageDir = File.fromUri(Platform.script).parent.parent.parent;
  final pubspec = File(p.join(packageDir.path, 'pubspec.yaml'));

  if (!pubspec.existsSync()) return 'Unknown';

  final content = pubspec.readAsStringSync();
  final doc = loadYaml(content);
  return doc['version'] ?? 'Unknown';
}
