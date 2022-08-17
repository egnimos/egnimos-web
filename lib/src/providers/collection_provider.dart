import 'package:egnimos/main.dart';
import 'package:egnimos/src/models/collection_file.dart';
import 'package:flutter/cupertino.dart';

class CollectionProvider with ChangeNotifier {
  static const collectionFiles = "collection_files";
  static const userCollections = "user_collections";
  static const files = "files";
  static const extensions = "extensions";

  List<String> _collectionNames = [];
  List<String> _extensions = [];
  List<CollectionFile> _collFiles = [];

  List<String> get collectionNames => _collectionNames;
  List<String> get collectionExtensions => _extensions;
  List<CollectionFile> get collFiles => _collFiles;

  //save the file
  Future<void> saveFile(CollectionFile file) async {
    try {
      //check if the collection name exists
      final respVal = await firestoreInstance
          .collection(userCollections)
          .doc(file.userId)
          .get();
      //check if the extension name exists
      final respVal1 = await firestoreInstance
          .collection(userCollections)
          .doc(file.userId)
          .collection(collectionFiles)
          .doc(file.collectionName)
          .get();
      final isCollectionExists =
          (respVal.data()?["names"] ?? []).contains(file.collectionName);
      //save collection name, if the collection dosen't exists
      if (!isCollectionExists) {
        await firestoreInstance
            .collection(userCollections)
            .doc(file.userId)
            .set({
          "names": [file.collectionName],
        });
      }

      final isExtensionExists =
          (respVal1.data()?["names"] ?? []).contains(file.extensionName);
      //save extension name, if the extension doesn't exists
      if (!isExtensionExists) {
        await firestoreInstance
            .collection(userCollections)
            .doc(file.userId)
            .collection(collectionFiles)
            .doc(file.collectionName)
            .set({
          "names": [file.extensionName],
        });
      }

      //save file
      await firestoreInstance
          .collection(userCollections)
          .doc(file.userId)
          .collection(collectionFiles)
          .doc(file.collectionName)
          .collection(extensions)
          .doc(file.extensionName)
          .collection(files)
          .doc(file.id)
          .set(file.toJson());
      if (!_collectionNames.contains(file.collectionName)) {
        _collectionNames.add(file.collectionName);
      }
      if (!_extensions.contains(file.extensionName)) {
        _extensions.add(file.extensionName);
      }
      _collFiles.removeWhere((f) => f.id == file.id);
      _collFiles.add(file);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //get collections
  Future<void> getCollections(String userId) async {
    try {
      final resp =
          await firestoreInstance.collection(userCollections).doc(userId).get();
      // final response = await resp.reference.get();
      final datas = resp.data()?["names"] ?? [];
      final result = List<String>.from(datas);
      _collectionNames = result;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //get extensions
  Future<void> getExtensions(String userId, String collectionName) async {
    try {
      final response = await firestoreInstance
          .collection(userCollections)
          .doc(userId)
          .collection(collectionFiles)
          .doc(collectionName)
          .get();
      final datas = response.data()?["names"] ?? [];
      final result = List<String>.from(datas);
      _extensions = result;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //get files
  Future<void> getFiles(
      String userId, String collectionName, String extensionName) async {
    try {
      final response = await firestoreInstance
          .collection(userCollections)
          .doc(userId)
          .collection(collectionFiles)
          .doc(collectionName)
          .collection(extensions)
          .doc(extensionName)
          .collection(files)
          .get();
      List<CollectionFile> results = [];
      for (var doc in response.docs) {
        print(doc.id);
        results.add(
          CollectionFile.fromJson(
            doc.data(),
          ),
        );
      }
      _collFiles = results;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //delete the file
  Future<void> deleteFile(CollectionFile file) async {
    try {
      await firestoreInstance
          .collection(userCollections)
          .doc(file.userId)
          .collection(collectionFiles)
          .doc(file.collectionName)
          .collection(extensions)
          .doc(file.extensionName)
          .collection(files)
          .doc(file.id)
          .delete();
      _collFiles.removeWhere((file) => file.id == file.id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
