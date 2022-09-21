import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class Chat extends Equatable {
  const Chat({
    this.id = '',
    this.text = '',
    this.dateTime = 0,
    this.isMyChat = false,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  Map<String, dynamic> toJson() => _$ChatToJson(this);

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final int dateTime;

  @HiveField(3)
  final bool isMyChat;

  static const empty = Chat();

  @override
  List<Object> get props => [id, text, dateTime, isMyChat];

  @override
  String toString() {
    return 'Chat(id: $id, text: $text, dateTime: $dateTime, isMyChat: $isMyChat)';
  }
}
