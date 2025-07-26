import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class GoogleSignIn implements UseCaseNoParams<UserEntity> {
  final AuthRepository repository;

  GoogleSignIn(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call() async {
    return await repository.signInWithGoogle();
  }
}
