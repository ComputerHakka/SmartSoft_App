import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/review.dart';
import 'base_review_repository.dart';

class ReviewRepository extends BaseReviewRepository {
  final FirebaseFirestore _firebaseFirestore;

  ReviewRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Review>> getAllReviews() {
    return _firebaseFirestore.collection('reviews').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Review.fromSnapshot(doc)).toList();
    });
  }

  @override
  Future<void> addReview(Review review) {
    return _firebaseFirestore.collection('reviews').add(review.toDocument());
  }

  @override
  Future<void> deleteReview(Review review) {
    return _firebaseFirestore.collection('reviews').doc(review.id).delete();
  }
}
