import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PickerService {
  Future<PlatformFile?> pick(
    BuildContext context, {
    required FileType fileType,
  }) async {
    try {
      final xFile = await FilePicker.platform.pickFiles(
        type: fileType,
      );

      if (xFile == null) {
        throw Exception("xfile is null");
      }

      return xFile.files.first;
    } on PlatformException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey.shade800,
          content: Text(error.toString()),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey.shade800,
          content: Text(error.toString()),
        ),
      );
    }
    return null;
  }
}
