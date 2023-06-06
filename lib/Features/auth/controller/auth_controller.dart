import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Features/auth/view/login_view.dart';
import 'package:todoapp/Features/home/view/home_view.dart';
import 'package:todoapp/api/auth_api.dart';
import 'package:todoapp/api/user_api.dart';
import 'package:todoapp/core/ustils.dart';
import 'package:appwrite/models.dart' as model;
import 'package:todoapp/models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider<Authcontroller, bool>((ref) {
  return Authcontroller(
    userAPI: ref.watch(userAPIProvider),
    authAPI: ref.watch(authAPIProvider),
  );
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserID = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserID));
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class Authcontroller extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  Authcontroller({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  //Loading(While Saving data to appwrite dashboard)

  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: getNameFromEmail(email),
          uid: r.$id,
          followers: const [],
          following: const [],
          profilePic: '',
          bannerPic: '',
          bio: '',
          isTwitterBlue: false,
        );
        final res2 = await _userAPI.saveUserData(userModel);
        res2.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, "SignUp Sucessful, Please Login");
          Navigator.push(context, LoginView.route());
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.push(context, HomeView.route());
      },
    );
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }
}
