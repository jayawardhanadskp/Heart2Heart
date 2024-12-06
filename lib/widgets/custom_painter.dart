import 'package:flutter/material.dart';
import '../models/drawing_area.dart';

class MyCustomPainter extends CustomPainter {
  final List<List<DrawingArea>> points;
  final List<DrawingArea> currentStroke;

  MyCustomPainter({required this.points, required this.currentStroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    // Draw completed strokes
    for (var stroke in points) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(
          stroke[i].point,
          stroke[i + 1].point,
          stroke[i].areaPaint,
        );
      }
    }

    // Draw current stroke
    for (int i = 0; i < currentStroke.length - 1; i++) {
      canvas.drawLine(
        currentStroke[i].point,
        currentStroke[i + 1].point,
        currentStroke[i].areaPaint,
      );
    }
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return true;  // Always repaint to ensure real-time updates
  }
}
