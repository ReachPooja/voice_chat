import 'package:dartz/dartz.dart';
import 'package:voice_chat/src/chat/models/conversation/conversation.dart';
import 'package:voice_chat/src/core/domain/failures/failures.dart';

abstract class IChatRepository {
  Future<Either<Failure, bool>> hasData();
  Future<Either<Failure, Unit>> saveConversation(Conversation conversation);
  Future<Either<Failure, List<Conversation>>> getConversation();
}
