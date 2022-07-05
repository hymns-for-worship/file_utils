import 'dart:typed_data';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

// Pick string file from html file input
Future<String?> pickStringFile({
  String extension = '*',
}) async {
  final binary = await pickBinaryFile(extension: extension);
  if (binary != null) {
    return String.fromCharCodes(binary);
  }
  return null;
}

// Save string file
Future<void> saveStringFile(
  String contents,
  String filename,
) async {
  final file = File(filename);
  if (!file.existsSync()) {
    await file.create(recursive: true);
  }
  await file.writeAsString(contents);
  await launchUrl(Uri.parse(file.path));
}

// Pick binary file
Future<Uint8List?> pickBinaryFile({
  String extension = '*',
}) async {
  final result = await FilePicker.platform.pickFiles(
    allowedExtensions: extension == '*' ? null : [extension],
    allowMultiple: false,
  );
  if (result != null && result.files.isNotEmpty) {
    final file = result.files.first;
    return file.bytes;
  }
  return null;
}

// Save binary file
Future<void> saveBinaryFile(
  List<int> contents,
  String filename,
) async {
  final file = File(filename);
  if (!file.existsSync()) {
    await file.create(recursive: true);
  }
  await file.writeAsBytes(contents);
  await launchUrl(Uri.parse(file.path));
}
