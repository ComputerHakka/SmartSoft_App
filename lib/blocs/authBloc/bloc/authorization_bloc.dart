import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:smartsoft_application/models/user.dart';
import 'package:smartsoft_application/repositories/authorization/auth_repository.dart';
import 'package:smartsoft_application/repositories/user/user_repository.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription<auth.User?>? _authUserSubscription;
  StreamSubscription<UserModel?>? _userSubscription;
  AuthorizationBloc(
      {required AuthRepository authRepository,
      required UserRepository userRepository})
      : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const AuthorizationState.unknown()) {
    on<AuthorizationUserChanged>(_onAuthorizationUserChanged);

    _authUserSubscription = _authRepository.user.listen(
      (authUser) {
        print('Auth user: $authUser');
        if (authUser != null) {
          _userRepository.getUser(authUser.uid).listen((user) {
            add(AuthorizationUserChanged(authUser: authUser, user: user));
          });
        } else {
          add(AuthorizationUserChanged(authUser: authUser));
        }
      },
    );
  }

  void _onAuthorizationUserChanged(
      AuthorizationUserChanged event, Emitter<AuthorizationState> emit) {
    event.authUser != null
        ? emit(AuthorizationState.authenticated(
            authUser: event.authUser!, user: event.user!))
        : emit(const AuthorizationState.unauthenticated());
  }

  @override
  Future<void> close() {
    _authUserSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}
