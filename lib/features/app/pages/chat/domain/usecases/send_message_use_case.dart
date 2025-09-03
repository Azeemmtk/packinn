import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/usecases/usecase.dart';
import 'package:packinn/features/app/pages/chat/domain/repository/chat_repository.dart';

class SendMessageUseCase extends UseCase<void, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) async {
    return repository.sendMessage(params.chatId, params.text);
  }
}

class SendMessageParams {
  final String chatId;
  final String text;

  SendMessageParams(this.chatId, this.text);
}
