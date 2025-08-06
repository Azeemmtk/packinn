import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/auth_repository.dart';

class ResetPassword implements UseCase<void, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPassword(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetPasswordParams params) async {
    if (params.email != null) {
      // Send password reset email
      return await repository.sendPasswordResetEmail(params.email!);
    } else if (params.newPassword != null && params.uid != null) {
      // Update password after OTP verification
      return await repository.updateUserPassword(params.uid!, params.newPassword!);
    }
    return Left(AuthFailure('Invalid parameters for password reset'));
  }
}

class ResetPasswordParams extends Equatable {
  final String? email;
  final String? uid;
  final String? newPassword;

  const ResetPasswordParams({this.email, this.uid, this.newPassword});

  @override
  List<Object?> get props => [email, uid, newPassword];
}