import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voice_chat/src/home/bloc/chat_history_bloc.dart';

Future<void> showDeleteConversationDialog(
  BuildContext context, {
  required String conversationId,
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) =>
        _DeleteConversationDialog(conversationId: conversationId),
  );
}

class _DeleteConversationDialog extends StatelessWidget {
  const _DeleteConversationDialog({required this.conversationId});

  final String conversationId;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Conversation #${conversationId.substring(0, 4)}?',
      ),
      content: const Text(
        'Are you sure, you want to delete this conversation?',
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          onPressed: () {
            context.read<ChatHistoryBloc>().add(
                  ConversationDeleted(
                    conversationId,
                  ),
                );
            Navigator.pop(context);
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
