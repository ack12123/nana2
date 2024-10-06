import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'file_downloader_mobile.dart';
import 'file_downloader_web.dart';

// 根据平台选择导入相应的文件
void downloadFile(String fileName, Uint8List bytes) {
  if (kIsWeb) {
    downloadFileWeb(fileName, bytes);
  } else {
    downloadFileMobile(fileName, bytes);
  }
}
