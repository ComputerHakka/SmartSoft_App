part of 'status_bloc.dart';

abstract class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object> get props => [];
}

class LoadStatusesEvent extends StatusEvent {}

class UpdateStatusesEvent extends StatusEvent {
  final List<Status> statuses;

  const UpdateStatusesEvent(this.statuses);

  @override
  List<Object> get props => [statuses];
}
