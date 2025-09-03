import 'package:dartz/dartz.dart';
import 'package:packinn/core/error/exceptions.dart';
import 'package:packinn/core/error/failures.dart';
import 'package:packinn/features/app/pages/chat/data/datasource/chat_remote_data_source.dart';
import 'package:packinn/features/app/pages/chat/domain/entity/chat_entity.dart';
import 'package:packinn/features/app/pages/chat/domain/entity/message_entity.dart';
import 'package:packinn/features/app/pages/chat/domain/repository/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository{

  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> createChat(String otherUserId) async{
    try{
      final result= await remoteDataSource.createChat(otherUserId);
      return Right(result);
    } on ServerException catch (e){
      return Left(ServerFailure(e.message));
    } catch (e){
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<ChatEntity>> getChats() {
    return remoteDataSource.getChats();
  }

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return remoteDataSource.getMessages(chatId);
  }

  @override
  Future<Either<Failure, void>> sendMessage(String chatId, String text) async{
    try{
      final  result = await remoteDataSource.sendMessage(chatId, text);
      return Right(result);
    } on ServerException catch (e){
      return Left(ServerFailure(e.message));
    } catch (e){
      return Left(ServerFailure(e.toString()));
    }
  }
  
}