import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:todoapp/core/core.dart';
import 'package:todoapp/core/providers.dart';
import 'package:todoapp/models/post_model.dart';

import '../Constants/Constants.dart';

final postAPIProvider = Provider((ref) {
  return PostAPI(
    realtime: ref.watch(appwriteRealtimeProvider),
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class IPostAPI {
  FuturEither<Document> sharePost(Post post);
  Future<List<Document>> getPosts();
  Stream<RealtimeMessage> getLatestPost();
}

class PostAPI implements IPostAPI {
  final Databases _db;
  final Realtime _realtime;
  PostAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FuturEither<Document> sharePost(Post post) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteContants.databaseID,
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
      databaseId: AppwriteContants.databaseID,
      collectionId: AppwriteContants.postCollection,
      queries: [
        Query.orderDesc('postedAt'),
      ], //if index in appwrite db dont workout remove Query
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestPost() {
    return _realtime.subscribe([
      'databases.${AppwriteContants.databaseID}.collections.${AppwriteContants.postCollection}.documents'
    ]).stream;
  }
}
