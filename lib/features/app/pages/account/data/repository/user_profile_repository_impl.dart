import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/exceptions.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/features/app/pages/account/data/datasource/user_profile_remote_data_source.dart';
import 'package:packinn/features/app/pages/account/domain/repository/user_profile_repository.dart';
import '../../../../../auth/data/model/user_model.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;

  UserProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserModel>> getUser(String uid) async {
    try {
      final user = await remoteDataSource.getUser(uid);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(UserModel user) async {
    try {
      await remoteDataSource.updateUser(user);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}