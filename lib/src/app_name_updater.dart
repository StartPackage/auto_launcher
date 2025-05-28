import 'dart:io';

import 'cli_formatter.dart';

void changeAppName(String newName) {
  if (newName.trim().isEmpty) {
    CliFormatter.printLogFormat(
      'Change app name skipped',
      ['App name is empty, skipping...'],
      status: 'failed',
    );
    return;
  }

  List<String> messages = [];
  bool androidSuccess = false;
  bool iosSuccess = false;

  // --- Android app name update ---
  final stringsPath = 'android/app/src/main/res/values/strings.xml';
  final stringsFile = File(stringsPath);
  final bool stringsExists = stringsFile.existsSync();

  try {
    if (!stringsExists) {
      print('strings.xml not found, creating default file...');
      final defaultContent = '''<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">$newName</string>
</resources>
''';
      stringsFile.createSync(recursive: true);
      stringsFile.writeAsStringSync(defaultContent);
      messages.add('✔ Created default strings.xml with app name.');
      androidSuccess = true;
    } else {
      var content = stringsFile.readAsStringSync();
      content = content.replaceAll(
          RegExp(r'<string name="app_name">[^<]+</string>'),
          '<string name="app_name">$newName</string>');
      stringsFile.writeAsStringSync(content);
      messages.add('✔ Android app name updated.');
      androidSuccess = true;
    }
  } catch (e) {
    messages.add('⚠ Error handling Android strings.xml: $e');
  }

  // --- iOS app name update ---
  final plistPath = 'ios/Runner/Info.plist';
  final plistFile = File(plistPath);

  if (plistFile.existsSync()) {
    try {
      var content = plistFile.readAsStringSync();
      content = content.replaceAll(
          RegExp(r'<key>CFBundleDisplayName</key>\s*<string>[^<]+</string>'),
          '<key>CFBundleDisplayName</key>\n  <string>$newName</string>');
      content = content.replaceAll(
          RegExp(r'<key>CFBundleName</key>\s*<string>[^<]+</string>'),
          '<key>CFBundleName</key>\n  <string>$newName</string>');
      plistFile.writeAsStringSync(content);

      messages.add('✔ iOS app name updated.');
      iosSuccess = true;
    } catch (e) {
      messages.add('⚠ Error updating iOS Info.plist: $e');
    }
  } else {
    messages.add('⚠ Info.plist not found, skipping iOS app name update.');
  }

  final overallStatus = (androidSuccess && iosSuccess) ? 'success' : 'error';
  final color = overallStatus == 'success' ? '\x1B[96m' : '\x1B[95m';

  CliFormatter.printLogFormat(
    'Updating app name to: \x1B[0m$newName$color',
    messages,
    status: overallStatus,
  );
}
