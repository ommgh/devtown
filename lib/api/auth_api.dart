import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todoapp/core/core.dart';
import 'package:todoapp/core/providers.dart';

final authAPIProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthAPI(account: account);
});

//For creating a new user profile we use model.account
abstract class IAuthAPI {
  FuturEither<model.Account> signUp({
    required String email,
    required String password,
  });

  FuturEither<model.Session> login({
    required String email,
    required String password,
  });
}

class AuthAPI implements IAuthAPI {
  final Account _account;
  AuthAPI({required Account account}) : _account = account;
  @override
  FuturEither<model.Account> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? "Something unexpected happened ", stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  FuturEither<model.Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _account.createEmailSession(
        email: email,
        password: password,
      );
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? "Something unexpected happened ", stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}
