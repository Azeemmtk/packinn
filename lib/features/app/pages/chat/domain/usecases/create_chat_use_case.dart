import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/usecases/usecase.dart';
import 'package:packinn/features/app/pages/chat/domain/repository/chat_repository.dart';

class CreateChatUseCase extends UseCase<String, String> {
  final ChatRepository repository;

  CreateChatUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String params) async {
    return await repository.createChat(params);
  }
}
