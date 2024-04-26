import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsoft_application/blocs/authBloc/bloc/authorization_bloc.dart';
import 'package:smartsoft_application/pages/authorization_page.dart';
import 'package:smartsoft_application/pages/registration_page.dart';
import 'package:smartsoft_application/pages/user_page.dart';
import 'package:smartsoft_application/repositories/user/user_repository.dart';

import '../blocs/profileBloc/bloc/profile_bloc.dart';
import '../repositories/authorization/auth_repository.dart';
import '../widgets/custom_appbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(
        authBloc: context.read<AuthorizationBloc>(),
        userRepository: context.read<UserRepository>(),
      )..add(
          LoadProfileEvent(
            context.read<AuthorizationBloc>().state.authUser,
          ),
        ),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Профиль',
          searchActivate: false,
          profilePage: true,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
          if (state is ProfileLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          if (state is ProfileLoadedState) {
            return UserPage(
              currentUser: state.user,
              currentContext: context,
            );
          }
          if (state is ProfileUnauthenticated) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  child: const Center(
                    child: Text(
                      'Уже есть аккаунт?\nТогда эта кнопка для вас\n▼',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthorizationPage(),
                      ),
                    );
                  },
                  child: const Text('Войти'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: const Center(
                    child: Text(
                      'Ещё не зарегистрированы\nв системе?\nСамое время это исправить!\n▼',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationPage(),
                      ),
                    );
                  },
                  child: const Text('Регистрация'),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text('Упс.. Что-то пошло не по плану'),
            );
          }
        }),
      ),
    );
  }
}
