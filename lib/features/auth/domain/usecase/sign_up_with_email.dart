import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/entity/user_entity.dart';
import '../repository/auth_repository.dart';

class SignUpWithEmail implements UseCase<UserEntity, SignUpParams> {
  final AuthRepository repository;

  SignUpWithEmail(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) async {
    return await repository.signUpWithEmail(
        params.name,
        params.email,
        params.phone,
        params.password,
    );
  }
}

class SignUpParams extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String password;

  const SignUpParams({required this.email, required this.password, required this.name, required this.phone,});

  @override
  List<Object> get props => [name, email, phone, password];
}
