import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:voice_chat/src/chat/models/conversation/conversation.dart';
import 'package:voice_chat/src/chat/repository/chat/i_chat_repository.dart';
import 'package:voice_chat/src/core/domain/failures/failures.dart';

@LazySingleton(as: IChatRepository)
class ChatRepository implements IChatRepository {
  static const chatBox = 'chatBox';
  @override
  Future<Either<Failure, bool>> hasData() async {
    try {
      final box = await Hive.openBox<Conversation>(chatBox);
      return right(box.isNotEmpty);
    } catch (e) {
      return left(
        Failure.error(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> saveConversation(
    Conversation conversation,
  ) async {
    try {
      final box = Hive.box<Conversation>(chatBox);
      await box.put(conversation.id, conversation);
      return right(unit);
    } catch (e) {
      return left(
        Failure.error(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<Conversation>>> getConversation() async {
    try {
      final box = Hive.box<Conversation>(chatBox);
      final conversations = <Conversation>[];
      final boxLength = box.values.length;
      for (var i = 0; i < boxLength; i++) {
        final convo = box.getAt(i);
        if (convo != null) {
          conversations.add(convo);
        }
      }
      return right(conversations);
    } catch (e) {
      return left(
        Failure.error(e.toString()),
      );
    }
  }

  @override
  Future<void> deleteConversation(String id) async {
    final box = Hive.box<Conversation>(chatBox);
    await box.delete(id);
  }
}
