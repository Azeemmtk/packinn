import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:packinn/core/entity/user_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/auth_repository.dart';


class VerifyOtp implements UseCase<UserEntity, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.verificationId, params.otp);
  }
}

class VerifyOtpParams extends Equatable {
  final String verificationId;
  final String otp;

  const VerifyOtpParams({required this.verificationId, required this.otp});

  @override
  List<Object> get props => [verificationId, otp];
}