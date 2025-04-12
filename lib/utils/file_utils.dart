import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> getCookiePath() async {
    final Directory tempDir = await getApplicationSupportDirectory();
    final String tempPath = "${tempDir.path}/.dldl/";
    final Directory dir = Directory(tempPath);
    final bool b = await dir.exists();
    if (!b) {
      dir.createSync(recursive: true);
    }
    return tempPath;
  }
}
