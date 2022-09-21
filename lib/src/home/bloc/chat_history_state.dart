part of 'chat_history_bloc.dart';

class ChatHistoryState extends Equatable {
  const ChatHistoryState({
    this.historyStatus = const Status.initial(),
    this.hasData,
    this.conversations = const [],
  });

  final Status historyStatus;
  final bool? hasData;
  final List<Conversation> conversations;

  @override
  List<Object?> get props => [historyStatus, hasData, conversations];

  ChatHistoryState copyWith({
    Status? historyStatus,
    bool? hasData,
    List<Conversation>? conversations,
  }) {
    return ChatHistoryState(
      historyStatus: historyStatus ?? this.historyStatus,
      hasData: hasData ?? this.hasData,
      conversations: conversations ?? this.conversations,
    );
  }
}
