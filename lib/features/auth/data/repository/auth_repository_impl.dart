import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../model/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Sign out failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Failed to get current user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isUserSignedIn() async {
    try {
      final isSignedIn = await remoteDataSource.isUserSignedIn();
      return Right(isSignedIn);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Failed to check auth status: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserToFirestore(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await remoteDataSource.saveUserToFirestore(userModel);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Failed to save user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getUserFromFirestore(String uid) async {
    try {
      final user = await remoteDataSource.getUserFromFirestore(uid);
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Failed to get user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      final updatedUser =
          await remoteDataSource.updateUserInFirestore(userModel);
      return Right(updatedUser);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(AuthFailure('Failed to update user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, String>> sendOtp(String phoneNumber) async {
    try {
      final verificationId = await remoteDataSource.sendOtp(phoneNumber);
      return Right(verificationId);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> verifyOtp(
      String verificationId, String otp) async {
    try {
      final user = await remoteDataSource.verifyOtp(verificationId, otp);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail(String email, String password) async{
    try{
      final user= await remoteDataSource.signInWithEmail(email, password);
      return Right(user);
    } on AuthFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail(String name, String email, String phone, String password) async{
    try{
      final user= await remoteDataSource.signUpWithEmail(name, email, phone, password);
      return Right(user);
    } catch (e){
      return Left(AuthFailure(e.toString()));
    }
  }
}
