import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:voice_chat/src/chat/bloc/chat_bloc.dart';
import 'package:voice_chat/src/chat/view/widgets/permission_denied_dialog.dart';
import 'package:voice_chat/src/chat/view/widgets/request_permission_dialog.dart';
import 'package:voice_chat/src/permissions/bloc/permissions_bloc.dart';
import 'package:voice_chat/src/permissions/repository/permissions_repository.dart';

class ChatInfoBar extends StatefulWidget {
  const ChatInfoBar({super.key});

  @override
  State<ChatInfoBar> createState() => _ChatInfoBarState();
}

class _ChatInfoBarState extends State<ChatInfoBar> {
  late TextEditingController _textController;
  MicPermissionStatus micPermissionStatus = MicPermissionStatus.none;

  @override
  void initState() {
    super.initState();

    _textController = TextEditingController();
    context.read<PermissionsBloc>().add(MicPermissionRequested());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PermissionsBloc, PermissionsState>(
          listenWhen: (previous, current) =>
              previous.micStatus != current.micStatus,
          listener: (context, state) {
            micPermissionStatus = state.micPermissionStatus;
            if (state.micPermissionStatus == MicPermissionStatus.granted) {
              context.read<ChatBloc>().add(SpeechInitialized());
            }
          },
        ),
        BlocListener<ChatBloc, ChatState>(
          listenWhen: (p, c) => p.currentText != c.currentText,
          listener: (context, state) {
            _textController.text = state.currentText;
          },
        ),
      ],
      child: BlocBuilder<ChatBloc, ChatState>(
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
                                hintText: '${state.isMyChat ? 'Thor' : 'Loki'}'
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
                                    showRequestPermissionDialog(context);
                                  }

                                  if (micPermissionStatus ==
                                      MicPermissionStatus.permanentDenied) {
                                    showPermissionDeniedDialog(context);
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
