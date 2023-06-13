import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/api/post_api.dart';
import 'package:todoapp/models/post_model.dart';

final userProfileControllerProvider = StateNotifierProvider((ref) {
  return UserProfileController(
    postAPI: ref.watch(postAPIProvider),
  );
});

final getUserPostsProvider = FutureProvider.family((ref, String uid) async {
  final UserProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return UserProfileController.getUserPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  UserProfileController({
    required PostAPI postAPI,
  })  : _postAPI = postAPI,
        super(false);

  Future<List<Post>> getUserPosts(String uid) async {
    final posts = await _postAPI.getUserPosts(uid);
    return posts.map((e) => Post.fromMap(e.data)).toList();
  }
}
