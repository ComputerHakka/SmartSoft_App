import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:smartsoft_application/models/user.dart';

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;
  Future<auth.User?> signUp({
    required String password,
    required UserModel user,
  });
  Future<String> logInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
}
