import 'dart:typed_data';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Pick string file from html file input
Future<String?> pickStringFile(
  BuildContext context, {
  String extension = '*',
}) async {
  final binary = await pickBinaryFile(context, extension: extension);
  if (binary != null) {
    return String.fromCharCodes(binary);
  }
  return null;
}

// Save string file
Future<void> saveStringFile(
  BuildContext context,
  String contents,
  String filename,
) async {
  await saveBinaryFile(context, contents.codeUnits, filename);
}

// Pick binary file
Future<Uint8List?> pickBinaryFile(
  BuildContext context, {
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
  BuildContext context,
  List<int> contents,
  String filename,
) async {
  final box = context.findRenderObject() as RenderBox?;
  final origin = box != null ? box.localToGlobal(Offset.zero) & box.size : null;
  final temp = await getApplicationDocumentsDirectory();
  final file = File('${temp.path}/downloads/$filename');
  if (!file.existsSync()) await file.create(recursive: true);
  await file.writeAsBytes(contents);
  await Share.shareFiles([file.path], sharePositionOrigin: origin);
}
