import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:voice_chat/src/chat/models/conversation/conversation.dart';
import 'package:voice_chat/src/chat/repository/chat/i_chat_repository.dart';
import 'package:voice_chat/src/core/domain/status/status.dart';

part 'chat_history_event.dart';
part 'chat_history_state.dart';

@injectable
class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {
  ChatHistoryBloc(this._chatRepository) : super(const ChatHistoryState()) {
    on<DataChecked>(_onDataChecked);
    on<DataRequested>(_onDataRequested);
  }

  final IChatRepository _chatRepository;

  Future<void> _onDataChecked(
    DataChecked event,
    Emitter<ChatHistoryState> emit,
  ) async {
    final result = await _chatRepository.hasData();
    result.map(
      (value) => emit(
        state.copyWith(
          hasData: value,
        ),
      ),
    );

    if (state.hasData!) {
      add(DataRequested());
    }
  }

  Future<void> _onDataRequested(
    DataRequested event,
    Emitter<ChatHistoryState> emit,
  ) async {
    final result = await _chatRepository.getConversation();
    emit(
      result.fold(
        (f) => state.copyWith(historyStatus: Status.failure(f)),
        (convo) {
          convo.sort(
            (a, b) => b.dateTime.compareTo(a.dateTime),
          );
          return state.copyWith(
            historyStatus: const Status.success(),
            conversations: convo,
          );
        },
      ),
    );
  }
}
