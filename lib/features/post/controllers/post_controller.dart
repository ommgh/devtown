import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todoapp/features/auth/controller/auth_controller.dart';
import 'package:todoapp/features/notifications/controller/notification_controller.dart';
import 'package:todoapp/features/post/widgets/post_list.dart';
import 'package:todoapp/api/notification_api.dart';
import 'package:todoapp/api/post_api.dart';
import 'package:todoapp/api/storage_api.dart';
import 'package:todoapp/core/enums/notification_type_enum.dart';
import 'package:todoapp/core/enums/post_type.dart';
import 'package:todoapp/core/ustils.dart';
import 'package:todoapp/models/post_model.dart';
import 'package:todoapp/models/user_model.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>(
  (ref) {
    return PostController(
      ref: ref,
      postAPI: ref.watch(postAPIProvider),
      storageAPI: ref.watch(storageAPIProvider),
      notificationController:
          ref.watch(notificationControllerProvider.notifier),
    );
  },
);

final getPostsProvider = FutureProvider((ref) {
  final postcontroller = ref.watch(postControllerProvider.notifier);
  return postcontroller.getPosts();
});

final getRepliesToPostsProvider = FutureProvider.family((ref, Post post) {
  final postcontroller = ref.watch(postControllerProvider.notifier);
  return postcontroller.getRepliesToPost(post);
});

final getLatestPostProvider = StreamProvider((ref) {
  final postAPI = ref.watch(postAPIProvider);
  return postAPI.getLatestPost();
});

final getPostByIdProvider = FutureProvider.family((ref, String id) async {
  final postcontroller = ref.watch(postControllerProvider.notifier);
  return postcontroller.getPostById(id);
});

final getPostsByHashtagProvider = FutureProvider.family((ref, String hashtag) {
  final postcontroller = ref.watch(postControllerProvider.notifier);
  return postcontroller.getPostsByHashtags(hashtag);
});

class PostController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final StorageAPI _storageAPI;
  final NotificationController _notificationController;
  final Ref _ref;
  PostController({
    required Ref ref,
    required PostAPI postAPI,
    required StorageAPI storageAPI,
    required NotificationController notificationController,
  })  : _ref = ref,
        _postAPI = postAPI,
        _storageAPI = storageAPI,
        _notificationController = notificationController,
        super(false);

  Future<List<Post>> getPosts() async {
    final postList = await _postAPI.getPosts();
    return postList.map((post) => Post.fromMap(post.data)).toList();
  }

  Future<Post> getPostById(String id) async {
    final post = await _postAPI.getPostById(id);
    return Post.fromMap(post.data);
  }

  void likePost(Post post, UserModel user) async {
    List<String> likes = post.likes;

    if (post.likes.contains(user.uid)) {
      likes.remove(user.uid);
    } else {
      likes.add(user.uid);
    }

    post = post.copyWith(likes: likes);
    final res = await _postAPI.likePost(post);
    res.fold((l) => null, (r) {
      _notificationController.createNotification(
        text: '${user.name} liked your tweet',
        postId: post.id,
        notificationType: NotificationType.like,
        uid: post.uid,
      );
    });
  }

  void sharePost({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, "Please Enter Some Text");
      return;
    }

    if (images.isNotEmpty) {
      _shareImagePost(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    } else {
      _shareTextPost(
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    }
  }

  Future<List<Post>> getRepliesToPost(Post post) async {
    final documents = await _postAPI.getRepliesToPost(post);
    return documents.map((post) => Post.fromMap(post.data)).toList();
  }

  Future<List<Post>> getPostsByHashtags(String hashtag) async {
    final documents = await _postAPI.getPostsByHashtags(hashtag);
    return documents.map((post) => Post.fromMap(post.data)).toList();
  }

  void _shareImagePost({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashtags = _getHastagFromtText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);
    Post post = Post(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      postType: PostType.image,
      postedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      repliedTo: repliedTo,
    );
    final res = await _postAPI.sharePost(post);

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: '${user.name} replied to your post',
          postId: r.$id,
          notificationType: NotificationType.reply,
          uid: repliedToUserId,
        );
      }
    });
    state = false;
  }

  void _shareTextPost({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashtags = _getHastagFromtText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Post post = Post(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      postType: PostType.text,
      postedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reshareCount: 0,
      repliedTo: repliedTo,
    );
    final res = await _postAPI.sharePost(post);

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: '${user.name} replied to your post',
          postId: r.$id,
          notificationType: NotificationType.reply,
          uid: repliedToUserId,
        );
      }
    });
    state = false;
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHastagFromtText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
