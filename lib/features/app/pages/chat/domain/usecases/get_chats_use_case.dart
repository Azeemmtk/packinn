import 'package:packinn/core/usecases/usecase.dart';
import 'package:packinn/features/app/pages/chat/domain/entity/chat_entity.dart';
import 'package:packinn/features/app/pages/chat/domain/repository/chat_repository.dart';

class GetChatsUseCase extends StreamUseCaseNoParams<List<ChatEntity>> {
  final ChatRepository repository;

  GetChatsUseCase(this.repository);

  @override
  Stream<List<ChatEntity>> call() {
    return repository.getChats();
  }
}
