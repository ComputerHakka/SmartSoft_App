part of 'status_bloc.dart';

abstract class StatusState extends Equatable {
  const StatusState();

  @override
  List<Object> get props => [];
}

class StatusLoadingState extends StatusState {}

class StatusLoadedState extends StatusState {
  final List<Status> statuses;

  const StatusLoadedState({this.statuses = const <Status>[]});

  @override
  List<Object> get props => [statuses];
}
