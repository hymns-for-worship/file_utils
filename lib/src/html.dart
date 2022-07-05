// ignore_for_file: avoid_web_libraries_in_flutter, unused_local_variable

import 'dart:html' as html;
import 'dart:typed_data';

// Pick string file from html file input
Future<String?> pickStringFile({
  String extension = '*',
}) async {
  final input = html.FileUploadInputElement();
  input.accept = extension;
  input.click();
  await input.onChange.first;
  final files = input.files ?? [];
  if (files.isNotEmpty) {
    final file = files.first;
    // Read file
    final reader = html.FileReader();
    reader.readAsText(file);
    await reader.onLoad.first;
    return reader.result as String;
  }
  return null;
}

// Save string file
Future<void> saveStringFile(
  String contents,
  String filename,
) async {
  final blob = html.Blob([contents.codeUnits], 'text/plain');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final link = html.AnchorElement()
    ..href = url
    ..download = filename
    ..click();
  html.Url.revokeObjectUrl(url);
}

// Pick binary file
Future<Uint8List?> pickBinaryFile({
  String extension = '*',
}) async {
  final input = html.FileUploadInputElement();
  input.accept = extension;
  input.click();
  await input.onChange.first;
  final files = input.files ?? [];
  if (files.isNotEmpty) {
    final file = files.first;
    // Read file
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;
    return reader.result as Uint8List;
  }
  return null;
}

// Save binary file
Future<void> saveBinaryFile(
  List<int> contents,
  String filename,
) async {
  final blob = html.Blob([contents], 'application/octet-stream');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final link = html.AnchorElement()
    ..href = url
    ..download = filename
    ..click();
  html.Url.revokeObjectUrl(url);
}
