import 'package:flutter/material.dart';
import 'package:paint/models/drawing_area.dart';

class DrawingProvider with ChangeNotifier {
  final List<List<DrawingArea>> _points = []; // Completed strokes
  List<DrawingArea> _currentStroke = []; // Current stroke being drawn
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  bool _isEraserActive = false;

  List<List<DrawingArea>> get points => _points;
  List<DrawingArea> get currentStroke => _currentStroke;
  Color get selectedColor => _selectedColor;
  double get strokeWidth => _strokeWidth;
  bool get isEraserActive => _isEraserActive;

  void setColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void setStrokeWidth(double width) {
    _strokeWidth = width;
    notifyListeners();
  }

  void toggleEraser() {
    _isEraserActive = !_isEraserActive;
    notifyListeners();
  }

  void startDrawing(Offset point) {
    if (_isEraserActive) {
      eraseLastLine();
    } else {
      _currentStroke = [
        DrawingArea(
          point: point,
          areaPaint: Paint()
            ..strokeCap = StrokeCap.round
            ..isAntiAlias = true
            ..color = _selectedColor
            ..strokeWidth = _strokeWidth
            ..style = PaintingStyle.stroke,
        )
      ];
    }
    notifyListeners();
  }

  void updateDrawing(Offset point) {
    if (!_isEraserActive) {
      _currentStroke.add(
        DrawingArea(
          point: point,
          areaPaint: Paint()
            ..strokeCap = StrokeCap.round
            ..isAntiAlias = true
            ..color = _selectedColor
            ..strokeWidth = _strokeWidth
            ..style = PaintingStyle.stroke,
        ),
      );
    }
    notifyListeners();
  }

  void endDrawing() {
    if (!_isEraserActive) {
      _points.add(List.from(_currentStroke));
      _currentStroke = [];
      print(_currentStroke);
      print(_points);
    }
    notifyListeners();
  }

  void eraseLastLine() {
    if (_points.isNotEmpty) {
      _points.removeLast();
      notifyListeners();
    }
  }

  void clear() {
    _points.clear();
    _currentStroke = [];
    notifyListeners();
  }
}
