import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import '../../../../../../core/model/user_model.dart';

abstract class UserDetailsRepository {
  Future<Either<Failure, UserModel>> getUser(String uid);
}