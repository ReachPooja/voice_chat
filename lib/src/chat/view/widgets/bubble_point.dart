import 'package:flutter/material.dart';

class BubblePoint extends CustomPainter {
  BubblePoint(this.bgColor);
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
