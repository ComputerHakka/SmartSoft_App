import 'package:bloc/bloc.dart';
import 'package:smartsoft_application/blocs/navigationBloc/nav_index_event.dart';
import 'package:smartsoft_application/blocs/navigationBloc/nav_index_state.dart';

class NavIndexBloc extends Bloc<NavIndexEvent, NavIndexState> {
  NavIndexBloc() : super(InitialState()) {
    on<SetIndexEvent>(onIndexChange);
  }

  void onIndexChange(SetIndexEvent event, Emitter<NavIndexState> emit) {
    emit(UpdateState(index: event.index));
  }
}
