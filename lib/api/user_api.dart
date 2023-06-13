import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todoapp/constants/appwrite_dependency.dart';
import 'package:todoapp/core/core.dart';
import 'package:todoapp/core/providers.dart';
import 'package:todoapp/models/user_model.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class IUserAPI {
  FuturEitherVoid saveUserData(UserModel userModel);
  Future<model.Document> getUserData(String uid);
  Future<List<model.Document>> searchUserByName(String name);
  FuturEitherVoid updateUserData(UserModel userModel);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  UserAPI({required Databases db}) : _db = db;

  @override
  FuturEitherVoid saveUserData(UserModel userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteContants.databaseID,
        collectionId: AppwriteContants.userCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some Unexpected Error Occured',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<model.Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppwriteContants.databaseID,
      collectionId: AppwriteContants.userCollection,
      documentId: uid,
    );
  }

  @override
  Future<List<model.Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteContants.databaseID,
      collectionId: AppwriteContants.userCollection,
      queries: [
        Query.search('name', name),
      ],
    );

    return documents.documents;
  }

  @override
  FuturEitherVoid updateUserData(UserModel userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteContants.databaseID,
        collectionId: AppwriteContants.userCollection,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some Unexpected Error Occured',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
