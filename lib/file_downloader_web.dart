import 'dart:typed_data';
import 'dart:html' as html;

void downloadFileWeb(String fileName, Uint8List bytes) {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', '$fileName.mp3')
    ..click();
  html.Url.revokeObjectUrl(url);
}
