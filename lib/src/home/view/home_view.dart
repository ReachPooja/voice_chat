import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:voice_chat/src/chat/view/chat_view.dart';
import 'package:voice_chat/src/home/bloc/chat_history_bloc.dart';

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
              child: BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
                builder: (context, state) {
                  if (state.hasData == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.hasData!) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 12),
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.conversations.length,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute<ChatView>(
                              builder: (context) => ChatView(
                                conversation: state.conversations[index],
                              ),
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
                          'Conversation ${state.conversations.length - index}',
                        ),
                        subtitle: Text(
                          dateFormatter(
                            state.conversations[index].dateTime,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("You don't have any chats"),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: SizedBox(
        height: 54,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute<ChatView>(
                  builder: (context) => const ChatView(),
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
            child: const Text(
              'Connect Me with a Random Person',
            ),
          ),
        ),
      ),
    );
  }
}

String dateFormatter(int milliseconds) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  final now = DateTime.now();

  final difference = now.difference(dateTime);

  if (difference.inHours < 24) {
    if (now.day == dateTime.day) {
      return DateFormat.jm().format(dateTime);
    } else {
      return 'yesterday';
    }
  } else {
    return DateFormat('dd MMM').format(dateTime);
  }
}
