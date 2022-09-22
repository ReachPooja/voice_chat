import 'package:flutter/material.dart';
import 'package:voice_chat/src/chat/models/chat/chat.dart';
import 'package:voice_chat/src/chat/view/widgets/chat_bubble.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            chat.isMyChat ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (chat.isMyChat)
            const SizedBox(
              width: 20,
            ),
          ChatBubble(
            chat: chat,
          ),
          if (!chat.isMyChat)
            const SizedBox(
              width: 20,
            ),
        ],
      ),
    );
  }
}
