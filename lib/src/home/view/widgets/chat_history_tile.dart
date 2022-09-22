import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_chat/src/chat/models/conversation/conversation.dart';
import 'package:voice_chat/src/chat/view/chat_view.dart';
import 'package:voice_chat/src/core/domain/helpers/date_formatter.dart';
import 'package:voice_chat/src/core/presentation/styles/colors.dart';
import 'package:voice_chat/src/home/bloc/chat_history_bloc.dart';
import 'package:voice_chat/src/home/view/widgets/delete_conversation_dialog.dart';

class ChatHistoryTile extends StatelessWidget {
  const ChatHistoryTile({
    super.key,
    required this.conversation,
  });

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context)
            .push(
          MaterialPageRoute<ChatView>(
            builder: (context) => ChatView(
              conversation: conversation,
            ),
            settings: const RouteSettings(name: 'ChatView'),
          ),
        )
            .whenComplete(
          () {
            context.read<ChatHistoryBloc>().add(
                  DataRequested(),
                );
          },
        );
      },
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: const Icon(
          Icons.chat_bubble_outline_rounded,
          size: 18,
        ),
      ),
      title: Text(
        'Conversation '
        '#${conversation.id.substring(0, 5)}',
      ),
      subtitle: Text(
        dateFormatter(
          conversation.dateTime,
        ),
        style: const TextStyle(
          color: AppColors.secondaryFontColor,
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          showDeleteConversationDialog(
            context,
            conversationId: conversation.id,
          );
        },
        icon: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.red,
        ),
      ),
    );
  }
}
