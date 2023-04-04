import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
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
  String contents,
  String filename, {
  bool share = true,
  BuildContext? context,
  String? mimeType,
}) async {
  await saveBinaryFile(
    contents.codeUnits,
    filename,
    share: share,
    context: context,
    mimeType: mimeType,
  );
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
Future<String> saveBinaryFile(
  List<int> contents,
  String filename, {
  BuildContext? context,
  String? mimeType,
  bool share = true,
}) async {
  if (share) {
    final p = defaultTargetPlatform;
    final file = XFile.fromData(
      Uint8List.fromList(contents),
      path: filename,
      mimeType: mimeType,
    );
    if (!(p == TargetPlatform.android || p == TargetPlatform.iOS)) {
      final path = await getSavePath(
        suggestedName: filename,
      );
      if (path != null) {
        await file.saveTo(path);
        return path;
      }
    }
    // ignore: use_build_context_synchronously
    final box = context?.findRenderObject() as RenderBox?;
    final origin = box != null ? box.localToGlobal(Offset.zero) & box.size : null;
    await Share.shareXFiles(
      [file],
      sharePositionOrigin: origin,
    );
    return '';
  }
  final temp = await getApplicationDocumentsDirectory();
  final file = File('${temp.path}/downloads/$filename');
  if (!file.existsSync()) await file.create(recursive: true);
  await file.writeAsBytes(contents);
  return file.path;
}

Future<Uint8List?> readBinaryFile(String filename) async {
  final temp = await getApplicationDocumentsDirectory();
  final file = File('${temp.path}/downloads/$filename');
  if (file.existsSync()) {
    final bytes = await file.readAsBytes();
    return bytes;
  }
  return null;
}

Future<String?> readStringFile(String filename) async {
  final bytes = await readBinaryFile(filename);
  if (bytes != null) {
    return String.fromCharCodes(bytes);
  }
  return null;
}

Future<void> deleteFile(String filename) async {
  final temp = await getApplicationDocumentsDirectory();
  final file = File('${temp.path}/downloads/$filename');
  if (file.existsSync()) {
    await file.delete();
  }
}
