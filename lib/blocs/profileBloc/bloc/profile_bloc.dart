import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartsoft_application/blocs/authBloc/bloc/authorization_bloc.dart';
import 'package:smartsoft_application/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:smartsoft_application/repositories/user/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthorizationBloc _authBloc;
  final UserRepository _userRepository;
  StreamSubscription? _authSubscription;
  ProfileBloc(
      {required AuthorizationBloc authBloc,
      required UserRepository userRepository})
      : _authBloc = authBloc,
        _userRepository = userRepository,
        super(ProfileLoadingState()) {
    on<LoadProfileEvent>(_onLoadProfileEvent);
    on<UpdateProfileEvent>(_onUpdateProfileEvent);
    on<ChangePhotoEvent>(_onChangePhotoEvent);
    on<EditUserEvent>(_onEditUserEvent);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.user != null) {
        add(LoadProfileEvent(state.authUser));
      }
    });
  }

  void _onLoadProfileEvent(LoadProfileEvent event, Emitter<ProfileState> emit) {
    if (event.authUser != null) {
      _userRepository.getUser(event.authUser!.uid).listen((user) {
        add(UpdateProfileEvent(user));
      });
    } else {
      emit(ProfileUnauthenticated());
    }
  }

  void _onUpdateProfileEvent(
      UpdateProfileEvent event, Emitter<ProfileState> emit) {
    emit(ProfileLoadedState(user: event.user));
  }

  void _onEditUserEvent(EditUserEvent event, Emitter<ProfileState> emit) async {
    await _userRepository.updateUser(event.user);
    add(UpdateProfileEvent(event.user));
  }

  void _onChangePhotoEvent(
      ChangePhotoEvent event, Emitter<ProfileState> emit) async {
    await _userRepository.changePhoto(event.user, event.photo);
    add(UpdateProfileEvent(event.user));
  }

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    super.close();
  }
}
