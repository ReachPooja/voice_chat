part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ListeningInitialized extends ChatEvent {}
class ListeningStarted extends ChatEvent{}
class ListeningEnded extends ChatEvent{}
