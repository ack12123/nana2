import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> downloadFileMobile(String fileName, Uint8List bytes) async {
  final directory = await getExternalStorageDirectory();
  final path = '${directory?.path}/Nana';
  final file = File('$path/$fileName.mp3');
  await file.writeAsBytes(bytes);
}
