part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SpeechInitialized extends ChatEvent {}

class IsListeningChanged extends ChatEvent {}

class ListeningStarted extends ChatEvent {}

class _ListeningCompleted extends ChatEvent {
  const _ListeningCompleted(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}

class _CurrentTextChanged extends ChatEvent {
  const _CurrentTextChanged(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}

class ListeningEnded extends ChatEvent {}

class ConversationAdded extends ChatEvent {
  const ConversationAdded(this.conversation);

  final Conversation conversation;

  @override
  List<Object> get props => [conversation];
}
