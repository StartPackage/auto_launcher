/// Main export file for the auto_launcher package
library auto_launcher;

export 'src/config_loader.dart';
export 'src/app_name_updater.dart';
export 'src/bundle_id_updater.dart';
export 'src/version_updater.dart';

import 'src/app_icon_updater.dart';
import 'src/config_loader.dart';
import 'src/app_name_updater.dart';
import 'src/bundle_id_updater.dart';
import 'src/cli_formatter.dart';
import 'src/version_updater.dart';

/// Entry point for CLI
void runAutoLauncher(List<String> args) async {
  if (args.isNotEmpty) {
    print('No arguments expected. Just run: dart run auto_launcher');
    return;
  }

  CliFormatter.printLogFormat(
    'Version: 0.0.1',
    ['👉👉👉 AUTO LAUNCHER 👈👈👈', '', 'Launching package...'],
  );

  print('');
  print('');
  print('');

  final config = loadAutoLauncherConfig();

  if (_isEnabled(config['app_name'])) {
    final appName = config['app_name']['build'];
    changeAppName(appName?.toString() ?? '');
  }

  if (_isEnabled(config['version'])) {
    final version = config['version']['build'];
    updateVersionAndBuild(version?.toString() ?? '');
  }

  final bundleIdConfig = config['bundle_id'];
  if (bundleIdConfig != null && bundleIdConfig['platforms'] is Map) {
    final platforms = bundleIdConfig['platforms'] as Map;
    final androidId = _isEnabled(platforms['android'])
        ? platforms['android']['build']?.toString()
        : null;
    final iosId = _isEnabled(platforms['ios'])
        ? platforms['ios']['build']?.toString()
        : null;
    changeBundleId(androidId, iosId);
  }

  final iconConfig = config['icon'];
  if (iconConfig != null && iconConfig['enable'] == true) {
    final imagePath = iconConfig['image_path'] ?? 'assets/icon/icon.png';
    await generateIcons(imagePath);
  }

  print('');
  print('');
  print('');
  // print('==> AUTO LAUNCHER FINISHED <==');
  // print('Thank you! ❤️');
  CliFormatter.printLogFormat(
    '💚💚💚  Thank you!  💚💚💚',
    ['✔ All tasks completed successfully!'],
  );
}

bool _isEnabled(dynamic section) {
  final enable = section['enable'];
  if (enable is bool && enable == true) {
    return true;
  }
  return false;
}
