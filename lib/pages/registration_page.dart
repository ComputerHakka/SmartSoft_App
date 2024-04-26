import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartsoft_application/cubits/registration/reg_cubit.dart';
import 'package:smartsoft_application/theme/app_theme.dart';

import '../widgets/custom_appbar.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Регистрация',
        searchActivate: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<RegistrationCubit, RegistrationState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _UserInput(
                  onChanged: (value) {
                    context.read<RegistrationCubit>().userChanged(
                          state.user!.copyWith(email: value),
                        );
                  },
                  labelText: 'Email',
                  icon: Icon(
                    Icons.email_outlined,
                    color: kAccentColor,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                _UserInput(
                  onChanged: (value) {
                    context.read<RegistrationCubit>().userChanged(
                          state.user!.copyWith(firstName: value),
                        );
                  },
                  labelText: 'Имя',
                  icon: Icon(
                    Icons.person,
                    color: kAccentColor,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                _UserInput(
                  onChanged: (value) {
                    context.read<RegistrationCubit>().userChanged(
                          state.user!.copyWith(lastName: value),
                        );
                  },
                  labelText: 'Фамилия',
                  icon: Icon(
                    Icons.person,
                    color: kAccentColor,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                _PasswordInput(),
                const SizedBox(
                  height: 10.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    var message = await context
                        .read<RegistrationCubit>()
                        .registrationWithCredentials();
                    if (message.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          elevation: 5,
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
                          content: Text(
                            message,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          elevation: 5,
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
                          content: Text(
                            'Регистрация прошла успешно',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Зарегистрироваться'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UserInput extends StatelessWidget {
  const _UserInput({
    Key? key,
    required this.onChanged,
    required this.labelText,
    required this.icon,
  }) : super(key: key);

  final Function(String?) onChanged;
  final String labelText;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        return TextField(
          onChanged: onChanged,
          decoration: InputDecoration(labelText: labelText, prefixIcon: icon),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        return TextField(
          onChanged: (password) {
            context.read<RegistrationCubit>().passwordChanged(password);
          },
          decoration: InputDecoration(
              labelText: 'Пароль',
              prefixIcon: Icon(
                Icons.lock,
                color: kAccentColor,
              )),
          obscureText: true,
        );
      },
    );
    ;
  }
}
