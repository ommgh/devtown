import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:todoapp/core/core.dart';
import 'package:todoapp/core/providers.dart';
import 'package:todoapp/models/post_model.dart';

import '../constants/constants.dart';

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
  FuturEither<Document> likePost(Post post);
  Future<List<Document>> getRepliesToPost(Post post);
  Future<Document> getPostById(String id);
  Future<List<Document>> getUserPosts(String uid);
  Future<List<Document>> getPostsByHashtags(String hashtag);
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
      ], //if index in appwrite db don't workout remove Query
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestPost() {
    return _realtime.subscribe([
      'databases.${AppwriteContants.databaseID}.collections.${AppwriteContants.postCollection}.documents'
    ]).stream;
  }

  @override
  FuturEither<Document> likePost(Post post) async {
    //liking function needs to be updated
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteContants.databaseID,
        collectionId: AppwriteContants.postCollection,
        documentId: post.id,
        data: {
          'likes': post.likes,
        },
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
  Future<List<Document>> getRepliesToPost(Post post) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteContants.databaseID,
      collectionId: AppwriteContants.postCollection,
      queries: [
        Query.equal(
          'repliedTo',
          post.id,
        ),
      ],
    );
    return document.documents;
  }

  @override
  Future<Document> getPostById(String id) async {
    return _db.getDocument(
      databaseId: AppwriteContants.databaseID,
      collectionId: AppwriteContants.postCollection,
      documentId: id,
    );
  }

  @override
  Future<List<Document>> getUserPosts(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteContants.databaseID,
      collectionId: AppwriteContants.postCollection,
      queries: [
        Query.equal('uid', uid),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getPostsByHashtags(String hashtag) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteContants.databaseID,
      collectionId: AppwriteContants.postCollection,
      queries: [
        Query.search('hashtags', hashtag),
      ],
    );
    return documents.documents;
  }
}
