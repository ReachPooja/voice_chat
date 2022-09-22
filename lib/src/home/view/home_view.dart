import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_chat/src/chat/view/chat_view.dart';
import 'package:voice_chat/src/home/bloc/chat_history_bloc.dart';
import 'package:voice_chat/src/home/view/widgets/chat_history_tile.dart';
import 'package:voice_chat/src/home/view/widgets/empty_conversations_display.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
                builder: (context, state) {
                  return state.historyStatus.maybeWhen(
                    success: () {
                      if (state.conversations.isEmpty) {
                        return const EmptyConversationsDisplay();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chat History',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 12),
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.conversations.length,
                              itemBuilder: (context, index) => ChatHistoryTile(
                                conversation: state.conversations[index],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    orElse: () => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromHeight(48),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute<ChatView>(
                      builder: (context) => const ChatView(),
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
                child: const Text('Connect Me with a Random Person'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
