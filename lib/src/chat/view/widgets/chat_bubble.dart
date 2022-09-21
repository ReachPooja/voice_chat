import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_chat/src/chat/view/widgets/bubble_point.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isMyChat,
    required this.text,
  });

  final bool isMyChat;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMyChat)
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: CustomPaint(
                painter: BubblePoint(Colors.orange.shade300),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isMyChat
                    ? Colors.deepPurple.shade100
                    : Colors.orange.shade300,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMyChat ? 18 : 0),
                  topRight: Radius.circular(isMyChat ? 0 : 18),
                  bottomLeft: const Radius.circular(18),
                  bottomRight: const Radius.circular(18),
                ),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (isMyChat)
            CustomPaint(
              painter: BubblePoint(
                Colors.deepPurple.shade100,
              ),
            ),
        ],
      ),
    );
  }
}
