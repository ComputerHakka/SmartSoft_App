import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';

import '../../repositories/authorization/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: AuthStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: AuthStatus.initial));
  }

  Future<String> logInWithCredentials() async {
    if (state.status == AuthStatus.submitting) return 'submitting';
    emit(state.copyWith(status: AuthStatus.submitting));
    if (state.isFormValid) {
      try {
        String answer = await _authRepository.logInWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );
        emit(state.copyWith(status: AuthStatus.success));
        return answer;
      } catch (e) {
        return 'Неизвестная ошибка';
      }
    } else {
      return 'Заполните все поля';
    }
  }
}
