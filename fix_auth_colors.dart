import 'dart:io';

void main() {
  final dir = Directory('lib/features/Auth');
  final files = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;

    // Backgrounds
    final bgColors = [
      'Color(0xffF6F7F8)',
      'Color(0xFFF6F7F8)',
      'Color(0xFFF8F9FB)',
      'Color(0xFFF1F5F9)',
    ];
    for (final bg in bgColors) {
      if (content.contains(bg)) {
        content = content.replaceAll('const \$bg', 'AppColors.backgroundColor');
        content = content.replaceAll(bg, 'AppColors.backgroundColor');
        changed = true;
      }
    }

    // Secondary Color (0F52BD)
    final secColors = ['Color(0xff0F52BD)', 'Color(0xFF0F52BD)'];
    for (final sec in secColors) {
      if (content.contains(sec)) {
        content = content.replaceAll('const \$sec', 'AppColors.secondaryColor');
        content = content.replaceAll(sec, 'AppColors.secondaryColor');
        changed = true;
      }
    }

    // Grey (475569, 64748B) -> AppColors.grey
    final greyColors = [
      'Color(0xff475569)',
      'Color(0xFF475569)',
      'Color(0xff64748B)',
      'Color(0xFF64748B)',
    ];
    for (final grey in greyColors) {
      if (content.contains(grey)) {
        content = content.replaceAll('const \$grey', 'AppColors.grey');
        content = content.replaceAll(grey, 'AppColors.grey');
        changed = true;
      }
    }

    // Light Grey (CBD5E1, E2E8F0, 94A3B8) -> AppColors.lightGrey
    final lightGreyColors = [
      'Color(0xffCBD5E1)',
      'Color(0xFFCBD5E1)',
      'Color(0xffE2E8F0)',
      'Color(0xFFE2E8F0)',
      'Color(0xff94A3B8)',
      'Color(0xFF94A3B8)',
      'Color(0xFFE0E7FF)',
    ];
    for (final lg in lightGreyColors) {
      if (content.contains(lg)) {
        content = content.replaceAll('const \$lg', 'AppColors.lightGrey');
        content = content.replaceAll(lg, 'AppColors.lightGrey');
        changed = true;
      }
    }

    // Dark text (334155) -> AppColors.darkBlue (which acts like pure reverse contrast)
    final darkTextColors = ['Color(0xff334155)', 'Color(0xFF334155)'];
    for (final dt in darkTextColors) {
      if (content.contains(dt)) {
        content = content.replaceAll('const \$dt', 'AppColors.darkBlue');
        content = content.replaceAll(dt, 'AppColors.darkBlue');
        changed = true;
      }
    }

    // Transparent secondary (0x190F52BD, 0x330F52BD) -> AppColors.secondaryColor.withOpacity
    if (content.contains('Color(0x190F52BD)')) {
      content = content.replaceAll(
        'const Color(0x190F52BD)',
        'AppColors.secondaryColor.withOpacity(0.1)',
      );
      content = content.replaceAll(
        'Color(0x190F52BD)',
        'AppColors.secondaryColor.withOpacity(0.1)',
      );
      changed = true;
    }
    if (content.contains('Color(0x330F52BD)')) {
      content = content.replaceAll(
        'const Color(0x330F52BD)',
        'AppColors.secondaryColor.withOpacity(0.2)',
      );
      content = content.replaceAll(
        'Color(0x330F52BD)',
        'AppColors.secondaryColor.withOpacity(0.2)',
      );
      changed = true;
    }

    // Shadows (0x19000000) -> Colors.black.withOpacity(0.1)
    if (content.contains('Color(0x19000000)')) {
      content = content.replaceAll(
        'const Color(0x19000000)',
        'Colors.black.withOpacity(0.1)',
      );
      content = content.replaceAll(
        'Color(0x19000000)',
        'Colors.black.withOpacity(0.1)',
      );
      changed = true;
    }

    // Remove any trailing `const AppColors` mistakes
    if (content.contains('const AppColors.')) {
      content = content.replaceAll('const AppColors.', 'AppColors.');
      changed = true;
    }

    if (changed) {
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
      print('Fixed \${file.path}');
    }
  }
}
