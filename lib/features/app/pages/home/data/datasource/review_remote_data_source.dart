import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:packinn/core/error/exceptions.dart';

import '../model/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<void> addReview(ReviewModel review);
  Stream<List<ReviewModel>> getReviews(String hostelId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final FirebaseFirestore firestore;

  ReviewRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> addReview(ReviewModel review) async {
    try {
      // Save the review to the reviews collection
      await firestore.collection('reviews').doc(review.id).set(review.toFirestore());
      print('Review saved to Firestore: ${review.id}');

      // Fetch all active reviews for the hostel to calculate average rating
      final reviewsSnapshot = await firestore
          .collection('reviews')
          .where('hostelId', isEqualTo: review.hostelId)
          .where('status', isEqualTo: 'Status.active')
          .get();

      final ratings = reviewsSnapshot.docs
          .map((doc) => (doc.data()['rating'] as num).toDouble())
          .toList();

      // Calculate average rating
      final averageRating = ratings.isNotEmpty
          ? ratings.reduce((a, b) => a + b) / ratings.length
          : review.rating.toDouble();
      print('Calculated average rating: $averageRating for hostelId: ${review.hostelId}');

      // Update the hostel's rating in the hostels collection
      await firestore.collection('hostels').doc(review.hostelId).update({
        'rating': averageRating,
      });
      print('Updated hostel rating: $averageRating for hostelId: ${review.hostelId}');
    } catch (e) {
      print('Error adding review or updating rating: $e');
      throw ServerException('Failed to add review or update rating: $e');
    }
  }

  @override
  Stream<List<ReviewModel>> getReviews(String hostelId) {
    try {
      return firestore
          .collection('reviews')
          .where('hostelId', isEqualTo: hostelId)
          .where('status', isEqualTo: 'Status.active')
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList());
    } catch (e) {
      throw ServerException('Failed to fetch reviews: $e');
    }
  }
}