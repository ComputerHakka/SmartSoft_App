part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class LoadReviewsEvent extends ReviewEvent {}

class UpdateReviewsEvent extends ReviewEvent {
  final List<Review> reviews;

  const UpdateReviewsEvent(this.reviews);

  @override
  List<Object> get props => [reviews];
}

class SendReviewEvent extends ReviewEvent {
  final Review review;

  const SendReviewEvent({required this.review});

  @override
  List<Object> get props => [review];
}

class DeleteReviewEvent extends ReviewEvent {
  final Review review;

  const DeleteReviewEvent(this.review);
  @override
  List<Object> get props => [review];
}
