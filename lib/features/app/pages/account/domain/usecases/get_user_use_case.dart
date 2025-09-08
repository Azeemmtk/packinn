import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/usecases/usecase.dart';
import 'package:packinn/features/app/pages/account/domain/repository/user_profile_repository.dart';

import '../../../../../auth/data/model/user_model.dart';

class GetUserUseCase implements UseCase<UserModel, String> {
  final UserProfileRepository repository;

  GetUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(String uid) async {
    return await repository.getUser(uid);
  }
}