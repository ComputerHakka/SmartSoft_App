part of 'review_bloc.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object> get props => [];
}

class ReviewLoadingState extends ReviewState {}

class ReviewLoadedState extends ReviewState {
  final List<Review> reviews;

  const ReviewLoadedState({this.reviews = const <Review>[]});

  @override
  List<Object> get props => [reviews];
}
