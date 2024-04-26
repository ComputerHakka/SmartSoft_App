import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/date_symbols.dart';
import 'package:smartsoft_application/repositories/authorization/auth_repository.dart';
import 'package:smartsoft_application/repositories/product/product_repository.dart';

import '../../../models/review.dart';
import '../../../repositories/review/review_repository.dart';
import '../../../repositories/user/user_repository.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _reviewRepository;
  final UserRepository _userRepository;
  StreamSubscription? _reviewSubscription;
  StreamSubscription? _userSubscription;
  ReviewBloc({
    required ReviewRepository reviewRepository,
    required UserRepository userRepository,
  })  : _reviewRepository = reviewRepository,
        _userRepository = userRepository,
        super(ReviewLoadingState()) {
    on<LoadReviewsEvent>(_onLoadReviews);
    on<UpdateReviewsEvent>(_onUpdateReviews);
    on<SendReviewEvent>(_onSendReview);
    on<DeleteReviewEvent>(_onDeleteReview);
  }

  void _onLoadReviews(LoadReviewsEvent event, Emitter<ReviewState> emit) {
    List<Review> userReviews = [];
    _reviewSubscription?.cancel();
    _reviewSubscription = _reviewRepository.getAllReviews().listen((reviews) {
      _userSubscription?.cancel();
      for (Review review in reviews) {
        _userSubscription =
            _userRepository.getUser(review.userId!.replaceAll(' ', '')).listen(
          (user) {
            userReviews.add(
              Review(
                id: review.id,
                text: review.text,
                rating: review.rating,
                userId: review.userId,
                productId: review.productId,
                user: user,
              ),
            );
            if (userReviews.length == reviews.length) {
              add(
                UpdateReviewsEvent(userReviews),
              );
            }
          },
        );
      }
    });
  }

  void _onUpdateReviews(UpdateReviewsEvent event, Emitter<ReviewState> emit) {
    emit(ReviewLoadedState(reviews: event.reviews));
  }

  void _onSendReview(SendReviewEvent event, Emitter<ReviewState> emit) async {
    if (state is ReviewLoadedState) {
      try {
        await _reviewRepository.addReview(event.review);
        print('Done');
        _reviewSubscription?.cancel();
        _reviewSubscription = _reviewRepository.getAllReviews().listen(
              (reviews) => add(
                LoadReviewsEvent(),
              ),
            );
      } catch (_) {}
    }
  }

  void _onDeleteReview(
      DeleteReviewEvent event, Emitter<ReviewState> emit) async {
    if (state is ReviewLoadedState) {
      try {
        await _reviewRepository.deleteReview(event.review);
        print('Done');
        _reviewSubscription?.cancel();
        _reviewSubscription = _reviewRepository.getAllReviews().listen(
              (reviews) => add(
                LoadReviewsEvent(),
              ),
            );
      } catch (_) {}
    }
  }
}
