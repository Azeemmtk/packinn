import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/core/usecases/usecase.dart';
import 'package:packinn/features/app/pages/chat/domain/entity/message_entity.dart';
import 'package:packinn/features/app/pages/chat/domain/repository/chat_repository.dart';

class GetMessagesUseCase extends StreamUseCase<List<MessageEntity>, String> {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  @override
  Stream<List<MessageEntity>> call(String params) {
    return repository.getMessages(params);
  }
}
