import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/usecases/usecase.dart';

import '../../data/model/review_model.dart';
import '../entity/review_entity.dart';
import '../repository/review_repository.dart';

class AddReviewUseCase implements UseCase<void, ReviewEntity> {
  final ReviewRepository repository;

  AddReviewUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ReviewEntity review) async {
    // Convert ReviewEntity to ReviewModel
    final reviewModel = ReviewModel(
      id: review.id,
      hostelId: review.hostelId,
      userId: review.userId,
      userName: review.userName,
      userImageUrl: review.userImageUrl,
      rating: review.rating,
      comment: review.comment,
      createdAt: review.createdAt,
      status: review.status,
    );
    return await repository.addReview(reviewModel);
  }
}