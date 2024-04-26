import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:smartsoft_application/models/user.dart';
import 'package:smartsoft_application/repositories/authorization/base_auth_repository.dart';
import 'package:smartsoft_application/repositories/user/user_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final UserRepository _userRepository;

  AuthRepository(
      {auth.FirebaseAuth? firebaseAuth, required UserRepository userRepository})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _userRepository = userRepository;

  @override
  Future<auth.User?> signUp({
    required UserModel user,
    required String password,
  }) async {
    try {
      if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(user.email)) {
        throw 'Введен некорректный Email адрес';
      }

      var methods = await _firebaseAuth.fetchSignInMethodsForEmail(user.email);

      if (methods.isNotEmpty) {
        throw 'Пользователь с таким Email уже существует';
      }

      _firebaseAuth
          .createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      )
          .then((value) {
        _userRepository.createUser(
          user.copyWith(id: value.user!.uid),
        );
      });
    } catch (_) {
      rethrow;
    }
    return null;
  }

  @override
  Future<String> logInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return '';
    } catch (e) {
      return 'Неверный логин или пароль';
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();
}
