import 'package:packinn/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> googleSignIn();
  Future<void> signOut();
  Future<UserEntity?> checkAuthStatus();
}
