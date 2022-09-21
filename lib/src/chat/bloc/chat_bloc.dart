import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:voice_chat/src/chat/models/chat/chat.dart';
import 'package:voice_chat/src/chat/models/conversation/conversation.dart';
import 'package:voice_chat/src/chat/repository/chat/i_chat_repository.dart';
import 'package:voice_chat/src/chat/repository/speech/i_speech_repository.dart';
import 'package:voice_chat/src/core/application/event_transformers/debounce_restartable.dart';
import 'package:voice_chat/src/core/domain/failures/failures.dart';
import 'package:voice_chat/src/core/domain/status/status.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._speechRepository, this._chatRepository)
      : super(const ChatState()) {
    on<SpeechInitialized>(_onSpeechInitialized);
    on<IsListeningChanged>(_onIsListeningChecked);
    on<ListeningStarted>(_onListeningStarted);
    on<_ListeningCompleted>(
      _onListeningCompleted,
      transformer: debounceRestartable(),
    );
    on<ListeningEnded>(_onListeningEnded);
    on<_CurrentTextChanged>(_onCurrentTextChanged);
  }

  final ISpeechRepository _speechRepository;
  final IChatRepository _chatRepository;

  Future<void> _onSpeechInitialized(
    SpeechInitialized event,
    Emitter<ChatState> emit,
  ) async {
    await _speechRepository.initialze();
  }

  void _onIsListeningChecked(
    IsListeningChanged event,
    Emitter<ChatState> emit,
  ) {
    final isListening = _speechRepository.isListening();
    emit(
      state.copyWith(
        isListening: isListening,
      ),
    );
  }

  Future<void> _onListeningStarted(
    ListeningStarted event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        speechStatus: const Status.loading(),
      ),
    );

    final result = await _speechRepository.listen(
      onResult: (text) {
        add(_CurrentTextChanged(text));
        add(_ListeningCompleted(text));
        add(IsListeningChanged());
      },
    );

    result.fold(
      (f) {
        if (f == const Failure.value('not-initialized')) {
          add(SpeechInitialized());
        }
        emit(
          state.copyWith(
            speechStatus: Status.failure(f),
          ),
        );
      },
      (_) {},
    );

    add(IsListeningChanged());
  }

  FutureOr<void> _onListeningEnded(
    ListeningEnded event,
    Emitter<ChatState> emit,
  ) async {
    await _speechRepository.stop();
    add(IsListeningChanged());
  }

  FutureOr<void> _onListeningCompleted(
    _ListeningCompleted event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(
        currentText: event.text,
      ),
    );
    if (event.text.isNotEmpty && !state.isListening) {
      Conversation conversation;

      if (state.conversation.isEmpty) {
        conversation = Conversation(
          id: const Uuid().v4(),
          dateTime: DateTime.now().millisecondsSinceEpoch,
        );
      } else {
        conversation = state.conversation;
      }

      final chat = Chat(
        id: const Uuid().v4(),
        dateTime: DateTime.now().millisecondsSinceEpoch,
        isMyChat: state.isMyChat,
        text: event.text,
      );

      emit(
        state.copyWith(
          speechStatus: const Status.success(),
          isMyChat: !state.isMyChat,
          conversation: conversation.copyWith(
            chats: List.of(conversation.chats)..add(chat),
          ),
          currentText: '',
        ),
      );

      _chatRepository.saveConversation(state.conversation);

      add(IsListeningChanged());
      add(ListeningEnded());
    } else {
      emit(
        state.copyWith(
          speechStatus: const Status.failure(
            Failure.value('Speak Clearly'),
          ),
        ),
      );
    }
  }

  void _onCurrentTextChanged(
    _CurrentTextChanged event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(
        currentText: event.text,
      ),
    );
  }
}
