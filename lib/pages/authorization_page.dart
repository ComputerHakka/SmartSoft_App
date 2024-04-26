import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsoft_application/blocs/profileBloc/bloc/profile_bloc.dart';
import 'package:smartsoft_application/cubits/authorization/auth_cubit.dart';
import 'package:smartsoft_application/repositories/authorization/auth_repository.dart';
import 'package:smartsoft_application/theme/app_theme.dart';

import '../widgets/custom_appbar.dart';

class AuthorizationPage extends StatelessWidget {
  const AuthorizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Авторизация',
        searchActivate: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _EmailInput(),
            const SizedBox(
              height: 15.0,
            ),
            _PasswordInput(),
            const SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              onPressed: () async {
                var message =
                    await context.read<AuthCubit>().logInWithCredentials();
                if (message.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      elevation: 5,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                      content: Text(
                        message,
                        textAlign: TextAlign.center,
                      )));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      elevation: 5,
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
                      content: Text(
                        'Вход выполнен успешно',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return TextField(
          onChanged: (email) {
            context.read<AuthCubit>().emailChanged(email);
          },
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(
              Icons.email_outlined,
              color: kAccentColor,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return TextField(
          onChanged: (password) {
            context.read<AuthCubit>().passwordChanged(password);
          },
          decoration: InputDecoration(
            labelText: 'Пароль',
            prefixIcon: Icon(Icons.lock, color: kAccentColor),
          ),
          obscureText: true,
        );
      },
    );
  }
}
