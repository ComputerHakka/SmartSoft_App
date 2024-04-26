import 'dart:io';

import 'package:smartsoft_application/models/user.dart';

abstract class BaseUserRepository {
  Stream<UserModel> getUser(String userId);
  Future<void> createUser(UserModel user);
  Future<void> updateUser(UserModel user);
  Future<void> changePhoto(UserModel user, File photo);
}
