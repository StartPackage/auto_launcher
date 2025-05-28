import 'package:auto_launcher/auto_launcher.dart';

void main() {
  print('Running auto_launcher example...');

  // Example: Change the app name
  changeAppName("My Flutter App");

  // Example: Change bundle IDs
  changeBundleId("com.example.android", "com.example.ios");

  // Example: Load configuration (usually from pubspec.yaml)
  final config = loadAutoLauncherConfig();
  print('Loaded config: $config');

  // Example: Update version and build
  updateVersionAndBuild("1.0.0+1");

  print('auto_launcher example completed.');
}
