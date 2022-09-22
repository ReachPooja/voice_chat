import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EmptyConversationsDisplay extends StatelessWidget {
  const EmptyConversationsDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lottie/empty_history.json',
        ),
        const Text(
          'You have not yet connected with anyone.\nStart chatting'
          ' with a random person\nby clicking the button below.',
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
}
