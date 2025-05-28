import 'dart:io';

import 'cli_formatter.dart';

void changeBundleId(String? androidId, String? iosId) {
  if ((androidId == null || androidId.isEmpty) &&
      (iosId == null || iosId.isEmpty)) {
    CliFormatter.printLogFormat(
      'Change bundle id skipped',
      ['✗ No valid bundle ID provided. Skipping...'],
      status: 'failed',
    );
    return;
  }

  List<String> messages = [];
  bool androidSuccess = false;
  bool iosSuccess = false;

  // --- Android bundle ID update ---
  if (androidId != null && androidId.isNotEmpty) {
    final manifest = File('android/app/src/main/AndroidManifest.xml');
    final gradle = File('android/app/build.gradle');

    try {
      if (manifest.existsSync()) {
        var content = manifest.readAsStringSync();
        content = content.replaceAll(
            RegExp(r'package="[^"]+"'), 'package="$androidId"');
        manifest.writeAsStringSync(content);
      } else {
        print('AndroidManifest.xml not found');
      }

      if (gradle.existsSync()) {
        var content = gradle.readAsStringSync();
        content = content.replaceAll(
            RegExp(r'applicationId\s+"[^"]+"'), 'applicationId "$androidId"');
        gradle.writeAsStringSync(content);
      } else {
        print('build.gradle not found');
      }
      androidSuccess = true;
      final color = androidSuccess ? '\x1B[96m' : '\x1B[95m';

      messages.add('$color✔ Android:\x1B[0m $androidId$color');
    } catch (e) {
      messages.add('⚠ Error updating Android bundle ID: $e');
    }
  }

  // --- iOS bundle ID update ---
  if (iosId != null && iosId.isNotEmpty) {
    final plist = File('ios/Runner/Info.plist');
    final pbxproj = File('ios/Runner.xcodeproj/project.pbxproj');

    try {
      if (plist.existsSync()) {
        var content = plist.readAsStringSync();
        content = content.replaceAll(
            RegExp(r'<key>CFBundleIdentifier</key>\s*<string>[^<]+</string>'),
            '<key>CFBundleIdentifier</key>\n	<string>$iosId</string>');
        plist.writeAsStringSync(content);
      } else {
        print('Info.plist not found');
      }

      if (pbxproj.existsSync()) {
        var content = pbxproj.readAsStringSync();
        content = content.replaceAll(
            RegExp(r'PRODUCT_BUNDLE_IDENTIFIER = [^;]+;'),
            'PRODUCT_BUNDLE_IDENTIFIER = $iosId;');
        pbxproj.writeAsStringSync(content);
      } else {
        print('project.pbxproj not found');
      }

      iosSuccess = true;
      final color = iosSuccess ? '\x1B[96m' : '\x1B[95m';

      messages.add('$color✔ iOS:\x1B[0m $iosId$color');
    } catch (e) {
      messages.add('⚠ Error updating iOS bundle ID: $e');
    }
  }

  final overallStatus = (androidSuccess && iosSuccess) ? 'success' : 'error';

  CliFormatter.printLogFormat(
    'Updating bundle id',
    messages,
    status: overallStatus,
  );
}
