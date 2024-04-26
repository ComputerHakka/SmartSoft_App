import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:smartsoft_application/models/user.dart';

import '../../repositories/authorization/auth_repository.dart';

part 'reg_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final AuthRepository _authRepository;

  RegistrationCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(RegistrationState.initial());

  void userChanged(UserModel user) {
    emit(state.copyWith(
      user: user,
      status: RegistrationStatus.initial,
    ));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: RegistrationStatus.initial));
  }

  Future<String> registrationWithCredentials() async {
    if (!state.isFormValid || state.status == RegistrationStatus.submitting) {
      return 'Не все данные были заполнены';
    }

    emit(state.copyWith(status: RegistrationStatus.submitting));
    try {
      var authUser = await _authRepository.signUp(
        password: state.password,
        user: state.user!,
      );
      emit(state.copyWith(
          status: RegistrationStatus.success, authUser: authUser));
      return '';
    } catch (e) {
      return e.toString();
    }
  }
}
