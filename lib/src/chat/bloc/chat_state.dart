part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState({
    this.speechStatus = const Status.initial(),
    this.isMyChat = true,
    this.currentText = '',
    this.isListening = false,
    this.conversation = Conversation.empty,
  });

  final Status speechStatus;
  final bool isMyChat;
  final String currentText;
  final bool isListening;
  final Conversation conversation;

  @override
  List<Object> get props {
    return [
      speechStatus,
      isMyChat,
      currentText,
      isListening,
      conversation,
    ];
  }

  ChatState copyWith({
    Status? speechStatus,
    bool? isMyChat,
    String? currentText,
    bool? isListening,
    Conversation? conversation,
  }) {
    return ChatState(
      speechStatus: speechStatus ?? this.speechStatus,
      isMyChat: isMyChat ?? this.isMyChat,
      currentText: currentText ?? this.currentText,
      isListening: isListening ?? this.isListening,
      conversation: conversation ?? this.conversation,
    );
  }

  @override
  String toString() {
    return 'ChatState(speechStatus: $speechStatus, isMyChat: $isMyChat,'
        ' currentText: $currentText, isListening: $isListening,'
        ' conversation: $conversation)';
  }
}
