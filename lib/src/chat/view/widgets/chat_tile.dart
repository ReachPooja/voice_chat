import 'package:flutter/material.dart';
import 'package:voice_chat/src/chat/view/widgets/chat_bubble.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    this.isMyChat = true,
    this.text = '',
  });

  final bool isMyChat;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isMyChat ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMyChat)
            const SizedBox(
              width: 20,
            ),
          ChatBubble(
            isMyChat: isMyChat,
            text: text,
          ),
          if (!isMyChat)
            const SizedBox(
              width: 20,
            ),
        ],
      ),
    );
  }
}
