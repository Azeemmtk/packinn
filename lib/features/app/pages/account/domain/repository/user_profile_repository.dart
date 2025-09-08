import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';

import '../../../../../auth/data/model/user_model.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserModel>> getUser(String uid);
  Future<Either<Failure, void>> updateUser(UserModel user);
}