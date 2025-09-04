import 'package:dartz/dartz.dart';
import '../../../../../../core/error/failures.dart';
import '../../domain/repository/review_repository.dart';
import '../datasource/review_remote_data_source.dart';
import '../model/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> addReview(ReviewModel review) async {
    try {
      await remoteDataSource.addReview(review);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<ReviewModel>> getReviews(String hostelId) {
    return remoteDataSource.getReviews(hostelId);
  }
}