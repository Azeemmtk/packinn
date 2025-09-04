import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import '../../data/model/review_model.dart';

abstract class ReviewRepository {
  Future<Either<Failure, void>> addReview(ReviewModel review);
  Stream<List<ReviewModel>> getReviews(String hostelId);
}
