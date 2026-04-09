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

    if (content.contains('const AppColors.backgroundColor')) {
      content = content.replaceAll(
        'const AppColors.backgroundColor',
        'AppColors.backgroundColor',
      );
      changed = true;
    }
    if (content.contains('AppColors.black54')) {
      content = content.replaceAll(
        'AppColors.black54',
        'AppColors.black.withOpacity(0.54)',
      );
      changed = true;
    }
    if (content.contains('AppColors.white.withOpacity')) {
      // AppColors.white is a getter, so `.withOpacity` works perfectly fine.
    }

    if (content.contains('const AppColors.')) {
      content = content.replaceAll('const AppColors.', 'AppColors.');
      changed = true;
    }

    if (changed) {
      file.writeAsStringSync(content);
      // ignore: avoid_print
      print('Fixed in \${file.path}');
    }
  }
}
