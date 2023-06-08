import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todoapp/constants/appwrite_dependency.dart';
import 'package:todoapp/core/core.dart';
import 'package:todoapp/core/providers.dart';
import 'package:todoapp/models/post_model.dart';

final postAPIProvider = Provider((ref) {
  return PostAPI(
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class IPostAPI {
  FuturEither<Document> sharePost(Post post);
  Future<List<Document>> getPosts();
}

class PostAPI implements IPostAPI {
  final Databases _db;
  PostAPI({required Databases db}) : _db = db;

  @override
  FuturEither<Document> sharePost(Post post) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteContants.dtatabaseID,
        collectionId: AppwriteContants.postCollection,
        documentId: ID.unique(),
        data: post.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getPosts() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteContants.dtatabaseID,
      collectionId: AppwriteContants.postCollection,
    );
    return documents.documents;
  }
}
