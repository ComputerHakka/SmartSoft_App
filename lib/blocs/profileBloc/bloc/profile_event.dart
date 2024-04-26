part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  final auth.User? authUser;

  const LoadProfileEvent(this.authUser);

  @override
  List<Object?> get props => [authUser];
}

class UpdateProfileEvent extends ProfileEvent {
  final UserModel user;

  const UpdateProfileEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class EditUserEvent extends ProfileEvent {
  final UserModel user;

  const EditUserEvent(this.user);
  @override
  List<Object?> get props => [user];
}

class ChangePhotoEvent extends ProfileEvent {
  final UserModel user;
  final File photo;

  const ChangePhotoEvent({required this.user, required this.photo});

  @override
  List<Object?> get props => [user, photo];
}
