part of 'authorization_bloc.dart';

enum AuthorizationStatus { unknown, authenticated, unauthenticated }

class AuthorizationState extends Equatable {
  final AuthorizationStatus status;
  final auth.User? authUser;
  final UserModel? user;

  const AuthorizationState._({
    this.status = AuthorizationStatus.unknown,
    this.authUser,
    this.user,
  });

  const AuthorizationState.unknown() : this._();

  const AuthorizationState.authenticated({
    required auth.User authUser,
    required UserModel user,
  }) : this._(
          status: AuthorizationStatus.authenticated,
          authUser: authUser,
          user: user,
        );

  const AuthorizationState.unauthenticated()
      : this._(
          status: AuthorizationStatus.unauthenticated,
        );

  @override
  List<Object?> get props => [status, authUser, user];
}
