import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartsoft_application/widgets/custom_appbar.dart';

import '../blocs/authBloc/bloc/authorization_bloc.dart';
import '../blocs/profileBloc/bloc/profile_bloc.dart';
import '../models/user.dart';
import '../repositories/user/user_repository.dart';

class UserEditPage extends StatefulWidget {
  final UserModel user;
  const UserEditPage({super.key, required this.user});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  TextEditingController _firsNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  String _firstNameValue = '';
  String _lastNameValue = '';

  @override
  void initState() {
    _firsNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _lastNameValue = widget.user.lastName;
    _firstNameValue = widget.user.firstName;
    super.initState();
  }

  @override
  void dispose() {
    _firsNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Редактирование',
        searchActivate: false,
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ProfileBloc(
            authBloc: context.read<AuthorizationBloc>(),
            userRepository: context.read<UserRepository>(),
          )..add(
              LoadProfileEvent(
                context.read<AuthorizationBloc>().state.authUser,
              ),
            ),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is ProfileLoadedState) {
                // _firsNameController.text = state.user.firstName;
                // _lastNameController.text = state.user.lastName;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 190, 190, 190),
                          ),
                          child: !state.user.imgUrl!.isNotEmpty
                              ? IconButton(
                                  onPressed: () async {
                                    ImagePicker imagePicker = ImagePicker();
                                    final pickedFile = await imagePicker
                                        .pickImage(source: ImageSource.gallery);

                                    if (pickedFile != null) {
                                      final photo = File(pickedFile.path);
                                      context.read<ProfileBloc>().add(
                                          ChangePhotoEvent(
                                              user: state.user, photo: photo));
                                    }
                                  },
                                  icon: const Icon(
                                      Icons.add_photo_alternate_outlined),
                                  color: Colors.black26,
                                  iconSize: 50.0,
                                )
                              : Image.network(
                                  state.user.imgUrl!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        state.user.imgUrl!.isNotEmpty
                            ? Positioned(
                                bottom: -5,
                                right: -5,
                                child: IconButton(
                                  onPressed: () async {
                                    ImagePicker imagePicker = ImagePicker();
                                    final pickedFile = await imagePicker
                                        .pickImage(source: ImageSource.gallery);

                                    if (pickedFile != null) {
                                      final photo = File(pickedFile.path);
                                      context.read<ProfileBloc>().add(
                                          ChangePhotoEvent(
                                              user: state.user, photo: photo));
                                    }
                                  },
                                  icon: const Icon(Icons.add_circle),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: TextFormField(
                        onChanged: (value) {
                          _firstNameValue = value;
                        },
                        controller: _firsNameController,
                        //initialValue: state.user.firstName,
                        decoration: const InputDecoration(
                          hintText: 'Введите имя',
                          label: Text('Имя'),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: TextFormField(
                        onChanged: (value) {
                          _lastNameValue = value;
                        },
                        controller: _lastNameController,
                        //initialValue: state.user.lastName,
                        decoration: const InputDecoration(
                          hintText: 'Введите фамилию',
                          label: Text('Фамилия'),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_lastNameValue.isNotEmpty &&
                            _firstNameValue.isNotEmpty) {
                          context.read<ProfileBloc>().add(EditUserEvent(
                              state.user.copyWith(
                                  firstName: _firstNameValue,
                                  lastName: _lastNameValue)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              elevation: 5,
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
                              content: Text(
                                'Имя и Фамилия не должны быть пустыми',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Сохранить'),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text('Упс...Что-то пошло не так'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
