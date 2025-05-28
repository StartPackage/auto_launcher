import 'dart:io';

import 'cli_formatter.dart';

/// Updates the app version and build number based on [versionString].
///
/// The [versionString] should be in the format `x.y.z+build`.
///
/// Prints an error message if the format is invalid.
void updateVersionAndBuild(String versionString) {
  if (!versionString.contains('+')) {
    CliFormatter.printLogFormat(
      'Change version skipped',
      ['✗ Invalid version format. Use format: x.y.z+build'],
      status: 'failed',
    );
    return;
  }

  final match = RegExp(r'(\d+\.\d+\.\d+)\+(\d+)').firstMatch(versionString);
  if (match == null) {
    CliFormatter.printLogFormat(
      'Change version skipped',
      ['✗ Invalid version format. Use format: x.y.z+build'],
      status: 'failed',
    );
    return;
  }
  final version = match.group(1)!;
  final build = match.group(2)!;

  List<String> messages = [];
  bool androidSuccess = false;
  bool iosSuccess = false;

  // Android local.properties or build.gradle
  final gradle = File('android/app/build.gradle');
  if (gradle.existsSync()) {
    var content = gradle.readAsStringSync();
    content = content.replaceAll(
        RegExp(r'versionName ".*"'), 'versionName "$version"');
    content =
        content.replaceAll(RegExp(r'versionCode \d+'), 'versionCode $build');
    gradle.writeAsStringSync(content);

    messages.add('✔ Android version updated.');
    androidSuccess = true;
  } else {
    messages.add('⚠ build.gradle not found, skipping Android version update.');
  }

  // iOS Info.plist
  final plist = File('ios/Runner/Info.plist');
  if (plist.existsSync()) {
    var content = plist.readAsStringSync();
    content = content.replaceAll(
        RegExp(
            r'<key>CFBundleShortVersionString</key>\s*<string>[^<]+</string>'),
        '<key>CFBundleShortVersionString</key>\n	<string>$version</string>');
    content = content.replaceAll(
        RegExp(r'<key>CFBundleVersion</key>\s*<string>[^<]+</string>'),
        '<key>CFBundleVersion</key>\n	<string>$build</string>');
    plist.writeAsStringSync(content);

    messages.add('✔ iOS version updated.');
    iosSuccess = true;
  } else {
    messages.add('⚠ Info.plist not found, skipping iOS version update.');
  }

  final overallStatus = (androidSuccess && iosSuccess) ? 'success' : 'error';
  final color = overallStatus == 'success' ? '\x1B[96m' : '\x1B[95m';

  CliFormatter.printLogFormat(
    'Updating version: \x1B[0m$version$color   build: \x1B[0m$build$color',
    messages,
    status: overallStatus,
  );
}
