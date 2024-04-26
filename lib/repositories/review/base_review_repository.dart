import '../../models/review.dart';

abstract class BaseReviewRepository {
  Stream<List<Review>> getAllReviews();
  Future<void> addReview(Review review);
  Future<void> deleteReview(Review review);
}
