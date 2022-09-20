import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: ListView.builder(
        controller: _controller,
        reverse: true,
        itemCount: 17,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) => ChatTile(
          isMyChat: index.isOdd,
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Person A',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {},
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  color: Theme.of(context).primaryColor,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Icon(
                      Icons.mic,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Text(
                'Person B',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

class CustomShape extends CustomPainter {
  CustomShape(this.bgColor);
  final Color bgColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = bgColor;

    final path = Path()
      ..lineTo(-5, 0)
      ..lineTo(0, 10)
      ..lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    this.isMyChat = true,
  });

  final bool isMyChat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isMyChat ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMyChat)
            const SizedBox(
              width: 20,
            ),
          ChatBubble(isMyChat: isMyChat),
          if (!isMyChat)
            const SizedBox(
              width: 20,
            ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isMyChat,
  });

  final bool isMyChat;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMyChat)
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: CustomPaint(
                painter: CustomShape(Colors.grey.shade300),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isMyChat ? Colors.blue.shade100 : Colors.grey.shade300,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMyChat ? 18 : 0),
                  topRight: Radius.circular(isMyChat ? 0 : 18),
                  bottomLeft: const Radius.circular(18),
                  bottomRight: const Radius.circular(18),
                ),
              ),
              child: const Text(
                'asdf asdfsdfsdf  asdfs',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (isMyChat)
            CustomPaint(
              painter: CustomShape(
                Colors.blue.shade100,
              ),
            ),
        ],
      ),
    );
  }
}
