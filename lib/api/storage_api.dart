import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Constants/appwrite_dependency.dart';
import 'package:todoapp/core/providers.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    storage: ref.watch(appwriteStorageProvider),
  );
});

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteContants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile.fromPath(
          path: file.path,
        ),
      );
      imageLinks.add(
        AppwriteContants.imageurl(uploadedImage.$id),
      );
    }
    return imageLinks;
  }
}
