part of 'chat_history_bloc.dart';

abstract class ChatHistoryEvent extends Equatable {
  const ChatHistoryEvent();

  @override
  List<Object> get props => [];
}

class DataChecked extends ChatHistoryEvent {}

class DataRequested extends ChatHistoryEvent {}

class ConversationDeleted extends ChatHistoryEvent {
  const ConversationDeleted(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}
