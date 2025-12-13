import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_third_app/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app bar title exists.
    expect(find.text('Moovie App'), findsOneWidget);
  });
}
