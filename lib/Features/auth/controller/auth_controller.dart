import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/api/auth_api.dart';
import 'package:todoapp/core/ustils.dart';

final authControllerProvider =
    StateNotifierProvider<Authcontroller, bool>((ref) {
  return Authcontroller(
    authAPI: ref.watch(authAPIProvider),
  );
});

class Authcontroller extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  Authcontroller({required AuthAPI authAPI})
      : _authAPI = authAPI,
        super(false);
  //Loading(While Saving data to appwrite dashboard)

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
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => print(r.email),
    );
  }
}
