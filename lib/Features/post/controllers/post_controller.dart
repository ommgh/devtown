import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todoapp/Features/auth/controller/auth_controller.dart';
import 'package:todoapp/Features/post/widgets/post_list.dart';
import 'package:todoapp/api/post_api.dart';
import 'package:todoapp/api/storage_api.dart';
import 'package:todoapp/core/enums/post_type.dart';
import 'package:todoapp/core/ustils.dart';
import 'package:todoapp/models/post_model.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>(
  (ref) {
    return PostController(
      ref: ref,
      postAPI: ref.watch(postAPIProvider),
      storageAPI: ref.watch(storageAPIProvider),
    );
  },
);

final getPostsProvider = FutureProvider((ref) {
  final postcontroller = ref.watch(postControllerProvider.notifier);
  return postcontroller.getPosts();
});

final getLatestPostProvider = StreamProvider((ref) {
  final postAPI = ref.watch(postAPIProvider);
  return postAPI.getLatestPost();
});

class PostController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;
  PostController({
    required Ref ref,
    required PostAPI postAPI,
    required StorageAPI storageAPI,
  })  : _ref = ref,
        _postAPI = postAPI,
        _storageAPI = storageAPI,
        super(false);

  Future<List<Post>> getPosts() async {
    final postList = await _postAPI.getPosts();
    return postList.map((post) => Post.fromMap(post.data)).toList();
  }

  void sharePost({
    required List<File> images,
    required String text,
    required BuildContext context,
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
      );
    } else {
      _shareTextPost(
        text: text,
        context: context,
      );
    }
  }

  void _shareImagePost({
    required List<File> images,
    required String text,
    required BuildContext context,
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
    );
    final res = await _postAPI.sharePost(post);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void _shareTextPost({
    required String text,
    required BuildContext context,
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
    );
    final res = await _postAPI.sharePost(post);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
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
