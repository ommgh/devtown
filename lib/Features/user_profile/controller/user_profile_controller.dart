import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/api/post_api.dart';
import 'package:todoapp/api/storage_api.dart';
import 'package:todoapp/api/user_api.dart';
import 'package:todoapp/core/ustils.dart';
import 'package:todoapp/models/post_model.dart';
import 'package:todoapp/models/user_model.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    postAPI: ref.watch(postAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final getUserPostsProvider = FutureProvider.family((ref, String uid) async {
  final UserProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return UserProfileController.getUserPosts(uid);
});

final getLatestUserProfileDataProvider = StreamProvider((ref) {
  final UserAPI = ref.watch(userAPIProvider);
  return UserAPI.getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;

  UserProfileController({
    required PostAPI postAPI,
    required StorageAPI storageAPI,
    required UserAPI userAPI,
  })  : _postAPI = postAPI,
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        super(false);

  Future<List<Post>> getUserPosts(String uid) async {
    final posts = await _postAPI.getUserPosts(uid);
    return posts.map((e) => Post.fromMap(e.data)).toList();
  }

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      final bannerUrl = await _storageAPI.uploadImage([bannerFile]);
      userModel = userModel.copyWith(
        bannerPic: bannerUrl[0],
      );
    }

    if (profileFile != null) {
      final profileUrl = await _storageAPI.uploadImage([profileFile]);
      userModel = userModel.copyWith(
        profilePic: profileUrl[0],
      );
    }

    final res = await _userAPI.updateUserData(userModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }
}
