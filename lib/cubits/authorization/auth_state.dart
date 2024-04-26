part of 'auth_cubit.dart';

enum AuthStatus { initial, submitting, success, error }

class AuthState extends Equatable {
  final String email;
  final String password;
  final AuthStatus status;
  final auth.User? user;

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  const AuthState({
    required this.email,
    required this.password,
    required this.status,
    this.user,
  });

  factory AuthState.initial() {
    return const AuthState(
      email: '',
      password: '',
      status: AuthStatus.initial,
      user: null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [email, password, status, user];

  AuthState copyWith({
    String? email,
    String? password,
    AuthStatus? status,
    auth.User? user,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
