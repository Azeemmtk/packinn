import 'package:packinn/features/auth/domain/entities/user_entity.dart';
import 'package:packinn/features/auth/domain/repository/auth_repository.dart';

class GoogleSignIn {
  final AuthRepository repository;

  GoogleSignIn(this.repository);

  Future<UserEntity?> call() async {
    return await repository.googleSignIn();
  }
}
