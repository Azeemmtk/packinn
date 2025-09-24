import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/usecases/usecase.dart';
import 'package:packinn/features/app/pages/account/domain/repository/user_profile_repository.dart';
import 'package:packinn/features/app/pages/home/domain/repository/user_details_repository.dart';

import '../../../../../../core/model/user_model.dart';

class GetUserDetailsUseCase implements UseCase<UserModel, String> {
  final UserDetailsRepository repository;

  GetUserDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(String uid) async {
    return await repository.getUser(uid);
  }
}