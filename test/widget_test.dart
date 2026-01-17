// Basic widget test for Chiya Town Cafe app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chiya_town_cafe/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ChiyaTownApp());

    // Verify that the app renders without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
