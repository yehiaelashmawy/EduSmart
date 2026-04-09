import 'dart:io';

void main() {
  final directory = Directory('lib');
  final files = directory
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;

    // We look for "const " followed by something that has "AppColors" on the same line.
    // Or specifically match the patterns we found:
    // const Icon(..., color: AppColors...)
    // const TextStyle(..., color: AppColors...)
    // const BorderSide(color: AppColors...)
    // const Divider(..., color: AppColors...)

    final regexes = [
      RegExp(r'const\s+(Icon\([^)]*AppColors[^)]*\))'),
      RegExp(r'const\s+(TextStyle\([^)]*AppColors[^)]*\))'),
      RegExp(r'const\s+(BorderSide\([^)]*AppColors[^)]*\))'),
      RegExp(r'const\s+(Divider\([^)]*AppColors[^)]*\))'),
    ];

    for (final regex in regexes) {
      if (regex.hasMatch(content)) {
        content = content.replaceAllMapped(regex, (match) => match.group(1)!);
        changed = true;
      }
    }

    if (changed) {
      file.writeAsStringSync(content);
      // ignore: avoid_print
      print('Updated ${file.path}');
    }
  }
}
