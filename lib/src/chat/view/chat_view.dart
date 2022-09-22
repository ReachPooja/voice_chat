import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'package:voice_chat/app/injector/injector.dart';
import 'package:voice_chat/src/chat/bloc/chat_bloc.dart';
import 'package:voice_chat/src/chat/models/conversation/conversation.dart';
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
        ..add(ConversationAdded(conversation))
        ..add(SpeechInitialized()),
      child: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ScrollController _controller;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ChatBloc, ChatState>(
            listenWhen: (p, c) => p.currentText != c.currentText,
            listener: (context, state) {
              _textController.text = state.currentText;
            },
          ),
          BlocListener<ChatBloc, ChatState>(
            listenWhen: (p, c) => p.conversation != c.conversation,
            listener: (context, state) {
              if (!_controller.hasClients) return;

              if (_controller.offset < _controller.position.maxScrollExtent) {
                final bottomOffset = _controller.position.maxScrollExtent +
                    kBottomNavigationBarHeight;
                _controller.animateTo(
                  bottomOffset,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return ListView.builder(
              controller: _controller,
              itemCount: state.conversation.chats.length,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final chat = state.conversation.chats[index];
                return ChatTile(
                  chat: chat,
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: state.isListening
                          ? TextField(
                              controller: _textController,
                              decoration: InputDecoration(
                                hintText:
                                    '${state.isMyChat ? 'Thor' : 'Loki'} is Speaking',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  state.isMyChat ? 'Thor' : 'Loki',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: state.isMyChat
                                        ? Colors.deepPurple
                                        : Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Tap mic to speak',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        return state.isListening
                            ? Lottie.asset(
                                'assets/lottie/wave.json',
                                height: 60,
                              )
                            : InkWell(
                                borderRadius: BorderRadius.circular(100),
                                onTap: () {
                                  if (state.isListening) {
                                    context
                                        .read<ChatBloc>()
                                        .add(ListeningEnded());
                                  } else {
                                    context
                                        .read<ChatBloc>()
                                        .add(ListeningStarted());
                                  }
                                },
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  color: state.isMyChat
                                      ? Colors.deepPurple
                                      : Colors.orange,
                                  child: const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Icon(
                                      Icons.mic,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          );
        },
      ),
    );
  }
}
