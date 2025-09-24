import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, bool>> isUserSignedIn();
  Future<Either<Failure, UserEntity>> signUpWithEmail(
      String name, String email, String phone, String password);
  Future<Either<Failure, UserEntity>> signInWithEmail(
      String email, String password);

  Future<Either<Failure, String>> sendOtp(String phoneNumber);
  Future<Either<Failure, UserEntity>> verifyOtp(
      String verificationId, String otp);

  // Firestore operations
  Future<Either<Failure, void>> saveUserToFirestore(UserEntity user);
  Future<Either<Failure, UserEntity?>> getUserFromFirestore(String uid);
  Future<Either<Failure, UserEntity>> updateUserProfile(UserEntity user);

  // Password reset operations
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  Future<Either<Failure, void>> updateUserPassword(String uid, String newPassword);
}