import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, UserEntity>> signInWithEmailPassword(String email, String password);
  Future<Either<Failure, UserEntity>> signUpWithEmailPassword(String email, String password);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, bool>> isUserSignedIn();
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  Future<Either<Failure, void>> verifyOTP(String otp);

  // New methods for Firestore operations
  Future<Either<Failure, void>> saveUserToFirestore(UserEntity user);
  Future<Either<Failure, UserEntity?>> getUserFromFirestore(String uid);
  Future<Either<Failure, UserEntity>> updateUserProfile(UserEntity user);
}
