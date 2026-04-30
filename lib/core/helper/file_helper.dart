import 'dart:io';
import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_system/core/helper/url_helper.dart';

class FileHelper {
  static final Dio _dio = Dio();

  static Future<void> downloadAndOpenFile({
    required String url,
    required String fileName,
  }) async {
    try {
      // 1. Check if the provided url is actually a local file path
      if (await File(url).exists()) {
        await OpenFilex.open(url);
        return;
      }

      // 2. If not a local file, treat it as a remote URL
      final String fullUrl = UrlHelper.getFullImageUrl(url);
      final Directory tempDir = await getTemporaryDirectory();
      
      // Ensure the filename is clean for the filesystem
      final String safeFileName = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
      final String filePath = '${tempDir.path}/$safeFileName';

      final File file = File(filePath);

      // Check if file already exists in cache
      if (!await file.exists()) {
        await _dio.download(
          fullUrl,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              print("${(received / total * 100).toStringAsFixed(0)}%");
            }
          },
        );
      }

      await OpenFilex.open(filePath);
    } catch (e) {
      print("Error downloading or opening file: $e");
      rethrow;
    }
  }
}
