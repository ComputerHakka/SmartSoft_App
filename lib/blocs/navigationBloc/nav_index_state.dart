class NavIndexState {}

class InitialState extends NavIndexState {}

class UpdateState extends NavIndexState {
  final int index;
  UpdateState({required this.index});
}
