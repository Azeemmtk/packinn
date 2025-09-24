import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/usecases/usecase.dart';
import 'package:packinn/features/app/pages/account/domain/repository/user_profile_repository.dart';

import '../../../../../../core/model/user_model.dart';

class UpdateUserUseCase implements UseCase<void, UserModel> {
  final UserProfileRepository repository;

  UpdateUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UserModel user) async {
    return await repository.updateUser(user);
  }
}