import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    if (file.path.contains('app_colors.dart') ||
        file.path.contains('theme_manager.dart')) {
      continue;
    }

    String content = file.readAsStringSync();
    bool changed = false;

    if (content.contains('Colors.white')) {
      content = content.replaceAll('Colors.white', 'AppColors.white');
      changed = true;
    }
    if (content.contains('Colors.black')) {
      content = content.replaceAll('Colors.black', 'AppColors.black');
      changed = true;
    }

    // Some places use Color(0xffF8FAFC) instead of AppColors.backgroundColor
    if (content.contains('Color(0xffF8FAFC)') ||
        content.contains('Color(0xFFF8FAFC)')) {
      content = content.replaceAll(
        RegExp(r'Color\(0xffF8FAFC\)', caseSensitive: false),
        'AppColors.backgroundColor',
      );
      changed = true;
    }

    // Also the bottom nav bar shadows might be hardcoded to black.
    // They will be fine if they use AppColors.black.

    if (changed) {
      // Need to ensure AppColors is imported if we are using it
      if (!content.contains(
        'package:school_system/core/utils/app_colors.dart',
      )) {
        // ignore: prefer_interpolation_to_compose_strings
        content =
            // ignore: prefer_interpolation_to_compose_strings
            "import 'package:school_system/core/utils/app_colors.dart';\n" +
            content;
      }
      file.writeAsStringSync(content);
      // ignore: avoid_print
      print('Fixed hardcoded colors in \${file.path}');
    }
  }
}
