import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/usecases/usecase.dart';
import 'package:packinn/features/auth/domain/repository/auth_repository.dart';

class SendOtp implements UseCase<String, String>{
  final AuthRepository repository;
  SendOtp(this.repository);
  @override
  Future<Either<Failure, String>> call(String phoneNumber) async{
    return await repository.sendOtp(phoneNumber);
  }

}