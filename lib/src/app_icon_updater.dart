import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

import 'cli_formatter.dart';

Future<void> generateIcons(String sourcePath) async {
  final sourceFile = File(sourcePath);
  if (!await sourceFile.exists()) {
    CliFormatter.printLogFormat(
      'Change app icon skipped',
      ['✗ Source icon not found at $sourcePath'],
      status: 'failed',
    );
    return;
  }

  final image = img.decodeImage(await sourceFile.readAsBytes());
  if (image == null) {
    CliFormatter.printLogFormat(
      'Change app icon skipped',
      ['✗ Failed to decode image.'],
      status: 'failed',
    );
    return;
  }

  List<String> messages = [];
  bool androidSuccess = false;
  bool iosSuccess = false;

  // Android icons
  try {
    final androidIcons = {
      'mipmap-mdpi': 48,
      'mipmap-hdpi': 72,
      'mipmap-xhdpi': 96,
      'mipmap-xxhdpi': 144,
      'mipmap-xxxhdpi': 192,
    };

    for (var entry in androidIcons.entries) {
      final resized =
          img.copyResize(image, width: entry.value, height: entry.value);
      final dir = Directory('android/app/src/main/res/${entry.key}');
      await dir.create(recursive: true);
      final file = File(p.join(dir.path, 'ic_launcher.png'));
      await file.writeAsBytes(img.encodePng(resized));
    }
    messages.add('✔ Android: Icons generated successfully');
    androidSuccess = true;
  } catch (e) {
    messages.add('❌ Failed to generate Android icons: $e');
  }

  // iOS icons
  try {
    final iosIcons = {
      'Icon-App-20x20@1x.png': 20,
      'Icon-App-20x20@2x.png': 40,
      'Icon-App-20x20@3x.png': 60,
      'Icon-App-29x29@1x.png': 29,
      'Icon-App-29x29@2x.png': 58,
      'Icon-App-29x29@3x.png': 87,
      'Icon-App-40x40@1x.png': 40,
      'Icon-App-40x40@2x.png': 80,
      'Icon-App-40x40@3x.png': 120,
      'Icon-App-60x60@2x.png': 120,
      'Icon-App-60x60@3x.png': 180,
      'Icon-App-76x76@1x.png': 76,
      'Icon-App-76x76@2x.png': 152,
      'Icon-App-83.5x83.5@2x.png': 167,
      'Icon-App-1024x1024@1x.png': 1024,
    };

    final iosDir = Directory('ios/Runner/Assets.xcassets/AppIcon.appiconset');
    await iosDir.create(recursive: true);

    for (var entry in iosIcons.entries) {
      final resized =
          img.copyResize(image, width: entry.value, height: entry.value);
      final file = File(p.join(iosDir.path, entry.key));
      await file.writeAsBytes(img.encodePng(resized));
    }

    // Write Contents.json
    final contentsJson = {
      "images": iosIcons.entries.map((entry) {
        final size = entry.key
            .split('@')[0]
            .replaceAll('Icon-App-', '')
            .replaceAll('x', 'x');
        final scale = entry.key.contains('@2x')
            ? "2x"
            : entry.key.contains('@3x')
                ? "3x"
                : "1x";
        return {
          "idiom": "iphone",
          "size": size,
          "scale": scale,
          "filename": entry.key,
        };
      }).toList(),
      "info": {"version": 1, "author": "xcode"}
    };

    final contentsFile = File(p.join(iosDir.path, 'Contents.json'));
    await contentsFile
        .writeAsString(JsonEncoder.withIndent('  ').convert(contentsJson));
    messages.add('✔ iOS: Icons generated successfully');
    iosSuccess = true;
  } catch (e) {
    messages.add('❌ Failed to generate iOS icons: $e');
  }

  final overallStatus = (androidSuccess && iosSuccess) ? 'success' : 'error';

  CliFormatter.printLogFormat(
    'Updating app icon',
    messages,
    status: overallStatus,
    isLast: true,
  );
}
