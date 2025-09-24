import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/exceptions.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/features/app/pages/account/data/datasource/user_profile_remote_data_source.dart';
import 'package:packinn/features/app/pages/account/domain/repository/user_profile_repository.dart';
import 'package:packinn/features/app/pages/home/data/datasource/user_details_remote_data_source.dart';
import 'package:packinn/features/app/pages/home/domain/repository/user_details_repository.dart';
import '../../../../../../core/model/user_model.dart';

class UserDetailsRepositoryImpl implements UserDetailsRepository {
  final UserDetailsRemoteDataSource remoteDataSource;

  UserDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserModel>> getUser(String uid) async {
    try {
      final user = await remoteDataSource.getUser(uid);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}