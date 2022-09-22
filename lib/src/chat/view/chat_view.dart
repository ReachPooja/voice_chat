
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'package:voice_chat/app/injector/injector.dart';
import 'package:voice_chat/src/chat/bloc/chat_bloc.dart';
import 'package:voice_chat/src/chat/models/conversation/conversation.dart';
import 'package:voice_chat/src/chat/view/widgets/chat_tile.dart';
import 'package:voice_chat/src/permissions/bloc/permissions_bloc.dart';
import 'package:voice_chat/src/permissions/repository/permissions_repository.dart';

class ChatView extends StatelessWidget {
  const ChatView({
    super.key,
    this.conversation = Conversation.empty,
  });

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ChatBloc>()..add(ConversationAdded(conversation)),
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
  MicPermissionStatus micPermissionStatus = MicPermissionStatus.none;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _textController = TextEditingController();
    context.read<PermissionsBloc>().add(MicPermissionRequested());
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PermissionsBloc, PermissionsState>(
      listenWhen: (previous, current) =>
          previous.micStatus != current.micStatus,
      listener: (context, state) {
        micPermissionStatus = state.micPermissionStatus;
        if (state.micPermissionStatus == MicPermissionStatus.granted) {
          context.read<ChatBloc>().add(SpeechInitialized());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
        ),
        body: BlocListener<ChatBloc, ChatState>(
          listenWhen: (p, c) => p.currentText != c.currentText,
          listener: (context, state) {
            _textController.text = state.currentText;
          },
          child: BlocBuilder<ChatBloc, ChatState>(
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
                controller: _controller,
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
                                readOnly: true,
                                controller: _textController,
                                decoration: InputDecoration(
                                  hintText:
                                      '${state.isMyChat ? 'Thor' : 'Loki'}'
                                      ' is Speaking',
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
                                    if (micPermissionStatus ==
                                        MicPermissionStatus.granted) {
                                      context
                                          .read<ChatBloc>()
                                          .add(ListeningStarted());
                                    }
                                    if (micPermissionStatus ==
                                        MicPermissionStatus.denied) {
                                      requestPermissionDialog(context);
                                    }

                                    if (micPermissionStatus ==
                                        MicPermissionStatus.permanentDenied) {
                                      permissionDeniedDialog(context);
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
      ),
    );
  }

  Future<void> requestPermissionDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Permission Denied',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'You have been denied access to the microphone.\nPlease grant'
                  ' permission to access the microphone',
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: const Text(
                        'Cancel',
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        context
                            .read<PermissionsBloc>()
                            .add(MicPermissionRequested());
                        Navigator.popUntil(
                          context,
                          (route) => route.settings.name == 'ChatView',
                        );
                      },
                      child: const Text('Allow'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> permissionDeniedDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Permission Denied Permanently',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  'You have been permanently denied access to the microphone'
                  '\nNow to access the microphone, please go to the device '
                  'settings and enable microphone permissions',
                ),
                const SizedBox(
                  height: 4,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
