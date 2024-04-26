part of 'reg_cubit.dart';

enum RegistrationStatus { initial, submitting, success, error }

class RegistrationState extends Equatable {
  final String password;
  final RegistrationStatus status;
  final auth.User? authUser;
  final UserModel? user;

  bool get isFormValid =>
      user!.email.isNotEmpty &&
      password.isNotEmpty &&
      user!.firstName.isNotEmpty &&
      user!.lastName.isNotEmpty;

  const RegistrationState({
    required this.password,
    required this.status,
    this.authUser,
    this.user,
  });

  factory RegistrationState.initial() {
    return const RegistrationState(
      password: '',
      status: RegistrationStatus.initial,
      authUser: null,
      user: UserModel(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [password, status, authUser, user];

  RegistrationState copyWith({
    String? password,
    RegistrationStatus? status,
    auth.User? authUser,
    UserModel? user,
  }) {
    return RegistrationState(
      password: password ?? this.password,
      status: status ?? this.status,
      authUser: authUser ?? this.authUser,
      user: user ?? this.user,
    );
  }
}
