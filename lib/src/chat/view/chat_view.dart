import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'package:voice_chat/app/injector/injector.dart';
import 'package:voice_chat/src/chat/bloc/chat_bloc.dart';
import 'package:voice_chat/src/chat/models/conversation/conversation.dart';
import 'package:voice_chat/src/chat/view/widgets/chat_info_bar.dart';
import 'package:voice_chat/src/chat/view/widgets/chat_tile.dart';

class ChatView extends StatelessWidget {
  const ChatView({
    super.key,
    this.conversation = Conversation.empty,
  });

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChatBloc>()
        ..add(
          ConversationAdded(conversation),
        ),
      child: const _ChatPage(),
    );
  }
}

class _ChatPage extends StatelessWidget {
  const _ChatPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state.conversation.chats.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Lottie.asset(
                  'assets/lottie/empty_chat.json',
                  height: MediaQuery.of(context).size.width / 2,
                ),
                const Text(
                  'Tap the mic to start chatting.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }

          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: state.conversation.chats.length,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final chat = state.conversation
                  .chats[state.conversation.chats.length - index - 1];

              return ChatTile(chat: chat);
            },
          );
        },
      ),
      bottomNavigationBar: const ChatInfoBar(),
    );
  }
}
