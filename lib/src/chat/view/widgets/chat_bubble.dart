import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voice_chat/src/chat/models/chat/chat.dart';
import 'package:voice_chat/src/chat/view/widgets/bubble_point.dart';
import 'package:voice_chat/src/core/domain/helpers/date_formatter.dart';
import 'package:voice_chat/src/core/presentation/styles/colors.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.chat,
  });

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!chat.isMyChat)
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: CustomPaint(
                painter: BubblePoint(AppColors.personBLightColor),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: chat.isMyChat
                    ? AppColors.personALightColor
                    : AppColors.personBLightColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(chat.isMyChat ? 18 : 0),
                  topRight: Radius.circular(chat.isMyChat ? 0 : 18),
                  bottomLeft: const Radius.circular(18),
                  bottomRight: const Radius.circular(18),
                ),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.end,
                alignment: WrapAlignment.end,
                children: [
                  Text(
                    chat.text,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    dateFormatter(chat.dateTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.tertiaryFontColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (chat.isMyChat)
            CustomPaint(
              painter: BubblePoint(
                AppColors.personALightColor,
              ),
            ),
        ],
      ),
    );
  }
}
