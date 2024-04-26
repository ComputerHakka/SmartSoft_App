part of 'authorization_bloc.dart';

abstract class AuthorizationEvent extends Equatable {
  const AuthorizationEvent();

  @override
  List<Object?> get props => [];
}

class AuthorizationUserChanged extends AuthorizationEvent {
  final auth.User? authUser;
  final UserModel? user;

  const AuthorizationUserChanged({
    required this.authUser,
    this.user,
  });

  @override
  List<Object?> get props => [authUser, user];
}
