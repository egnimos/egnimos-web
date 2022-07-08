import 'package:cross_file/cross_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';

import '/main.dart';
import '../utility/enum.dart';

class MimeModel {
  String uploadType;
  String fileExt;
  PickerType type;

  MimeModel({
    required this.uploadType,
    required this.fileExt,
    required this.type,
  });
}

class UploadOutput {
  String fileName;
  String generatedUri;

  UploadOutput({
    required this.fileName,
    required this.generatedUri,
  });
}

class UploadProvider with ChangeNotifier {
  String uploadType = "files";
  String fileExt = "";
  PickerType fileType = PickerType.unknown;

  Future<UploadOutput> uploadFile(
    XFile file,
    String type,
    String ext, {
    String? fileN,
  }) async {
    try {
      String fileName = "";
      if (fileN == null) {
        final fileCodeName = const Uuid().v4();
        fileName = "$fileCodeName.$ext";
      } else {
        fileName = fileN;
      }
      final metaData = SettableMetadata(
        contentType: '$type/$ext',
        customMetadata: {
          'picked-file-path': file.path,
        },
      );
      //CreateRefernce to path.
      //https://firebasestorage.googleapis.com/v0/b/big-buddy-14d48.appspot.com/o/images%2Fa873a3f5-0318-4021-9843-ae108cccb663.jpeg?alt=media&token=f333412e-232e-4735-9699-0cef425bb5d7
      final ref = storage.ref().child("${type}s").child("/$fileName");
      final uploadTask = await ref.putData(await file.readAsBytes(), metaData);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return UploadOutput(
        fileName: fileName,
        generatedUri: downloadUrl,
      );
    } catch (error) {
      rethrow;
    }
  }

  MimeModel generateFileType(XFile file) {
    try {
      final mime = lookupMimeType(file.path);
      // uploadType = mime?.split("/").first ?? "files";
      // fileExt = mime?.split("/").last ?? "";
      print(file.mimeType);
      final fileMimieType = mime?.split("/").first == "application"
          ? mime?.split("/").last
          : mime?.split("/").first;
      fileType = PickerType.values.firstWhere(
        (val) => val.name == fileMimieType,
        orElse: () => PickerType.unknown,
      );
      return MimeModel(
        uploadType: uploadType,
        fileExt: fileExt,
        type: fileType,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFiles(String fileName, PickerType type) async {
    try {
      if (fileName.isEmpty) return;
      //CreateRefernce to path.
      final bucketName =
          type == PickerType.pdf ? "applications" : "${type.name}s";
      //https://firebasestorage.googleapis.com/v0/b/big-buddy-14d48.appspot.com/o/images%2Fa873a3f5-0318-4021-9843-ae108cccb663.jpeg?alt=media&token=f333412e-232e-4735-9699-0cef425bb5d7
      final ref = storage.ref().child(bucketName).child("/$fileName");
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }
}
