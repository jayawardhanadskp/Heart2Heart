import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:paint/services/firestore_service.dart';
import 'package:paint/models/drawing_area.dart';

class DrawingProvider with ChangeNotifier {
  final List<List<DrawingArea>> _points = []; // Completed strokes
  List<DrawingArea> _currentStroke = []; // Current stroke being drawn
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  bool _isEraserActive = false;
  String? _pairId;  // Store the pairId to sync drawings

  List<List<DrawingArea>> get points => _points;
  List<DrawingArea> get currentStroke => _currentStroke;
  Color get selectedColor => _selectedColor;
  double get strokeWidth => _strokeWidth;
  bool get isEraserActive => _isEraserActive;

  // Set the paired user id to sync drawings
  void setPairId(String pairId) {
    _pairId = pairId;
    notifyListeners();
  }

  // Sync drawing with Firestore
  Future<void> syncDrawing() async {
    if (_pairId != null) {
      await FirestoreService().saveDrawing(
        _pairId!,
        _points.expand((x) => x).map((area) => area.point).toList(),
        _strokeWidth,
        _selectedColor,
      );
    }
  }

  // Listen to the real-time drawing updates
  Stream<DocumentSnapshot> getDrawingStream() {
    if (_pairId != null) {
      return FirestoreService().listenToDrawing(_pairId!);
    }
    return Stream.empty();
  }

  // Add a point to the current stroke
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
    }
    notifyListeners();
    syncDrawing();  // Sync drawing after each stroke
  }

  // Erase the last drawn line
  void eraseLastLine() {
    if (_points.isNotEmpty) {
      _points.removeLast();
      notifyListeners();
    }
  }

  // Clear the entire drawing
  void clear() {
    _points.clear();
    _currentStroke = [];
    notifyListeners();
    if (_pairId != null) {
      FirestoreService().saveDrawing(_pairId!, [], _strokeWidth, _selectedColor); // Clear Firestore too
    }
  }

  // Set the selected color
  void setColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  // Set the stroke width
  void setStrokeWidth(double width) {
    _strokeWidth = width;
    notifyListeners();
  }

  // Toggle the eraser tool
  void toggleEraser() {
    _isEraserActive = !_isEraserActive;
    notifyListeners();
  }
}
