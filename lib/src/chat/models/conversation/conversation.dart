import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:voice_chat/src/chat/models/chat/chat.dart';

part 'conversation.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class Conversation extends Equatable {
  const Conversation({
    this.id = '',
    this.dateTime = 0,
    this.chats = const [],
  });

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  @HiveField(0)
  final String id;

  @HiveField(1)
  final int dateTime;

  @HiveField(2)
  final List<Chat> chats;

  static const empty = Conversation();
  bool get isEmpty => this == empty;

  @override
  List<Object> get props => [id, dateTime, chats];

  Conversation copyWith({
    String? id,
    int? dateTime,
    List<Chat>? chats,
  }) {
    return Conversation(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      chats: chats ?? this.chats,
    );
  }

  @override
  String toString() =>
      'Conversation(id: $id, dateTime: $dateTime, chats: $chats)';
}
