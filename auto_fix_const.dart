import 'dart:io';

void main() {
  // ignore: avoid_print
  print('Running dart analyze...');
  final result = Process.runSync('dart', ['analyze']);
  final output = result.stdout.toString() + result.stderr.toString();

  final regex = RegExp(r'Invalid constant value[^\n]*\(([^\:]+)\:(\d+)\:\d+\)');
  final matches = regex.allMatches(output);

  // Group errors by file
  final Map<String, List<int>> fileErrors = {};
  for (final match in matches) {
    String path = match.group(1)!;
    int line = int.parse(match.group(2)!);
    // on windows dart analyze outputs relative paths like lib\features\...
    fileErrors.putIfAbsent(path, () => []).add(line);
  }

  for (final entry in fileErrors.entries) {
    final path = entry.key;
    final lines = entry.value;

    final file = File(path);
    if (!file.existsSync()) {
      // ignore: avoid_print
      print('File not found: $path');
      continue;
    }

    List<String> contentLines = file.readAsLinesSync();
    bool changed = false;

    // Sort lines descending so modifying one doesn't shift the others
    lines.sort((a, b) => b.compareTo(a));

    for (int lineNum in lines) {
      // lineNum is 1-indexed
      int idx = lineNum - 1;
      // Search backwards up to 30 lines for 'const '
      for (int i = 0; i < 30; i++) {
        if (idx - i >= 0 && contentLines[idx - i].contains('const ')) {
          contentLines[idx - i] = contentLines[idx - i].replaceFirst(
            'const ',
            '',
          );
          changed = true;
          break;
        }
      }
    }

    if (changed) {
      // ignore: prefer_interpolation_to_compose_strings
      file.writeAsStringSync(contentLines.join('\n') + '\n');
      // ignore: avoid_print
      print('Fixed errors in $path');
    }
  }
}
