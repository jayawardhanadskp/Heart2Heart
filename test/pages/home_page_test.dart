import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paint/pages/home_page.dart';

void main() {
  testWidgets('home page ...', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MyHomePage(),
    ));

    final btn = find.byType(ElevatedButton);
    expect(btn, findsOneWidget);
  });
}
