import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smartsoft_application/repositories/status/status_repository.dart';

import '../../../models/status.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final StatusRepository _statusRepository;
  StreamSubscription? _statusSubscription;
  StatusBloc({required StatusRepository statusRepository})
      : _statusRepository = statusRepository,
        super(StatusLoadingState()) {
    on<LoadStatusesEvent>(onLoadStatuses);
    on<UpdateStatusesEvent>(_onUpdateStatuses);
  }

  void onLoadStatuses(LoadStatusesEvent event, Emitter<StatusState> emit) {
    _statusSubscription?.cancel();
    _statusSubscription = _statusRepository.getAllStatuses().listen(
          (statuses) => add(
            UpdateStatusesEvent(statuses),
          ),
        );
  }

  void _onUpdateStatuses(UpdateStatusesEvent event, Emitter<StatusState> emit) {
    emit(StatusLoadedState(statuses: event.statuses));
  }
}
