import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glad_tools/tools/json_beautify/json_beautify_view.dart';

void main() {
  testWidgets("JSON Viewer can show util buttons", (WidgetTester tester) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(size: Size(500, 300)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: Scaffold(
              body: JsonBeautifyView(),

            ),
          ),
        ),
      ),
    );

    final buttonFinder = find.byType(TextButton);
    expect(buttonFinder, findsNWidgets(3), reason: "Three text buttons are shown");
  });

  testWidgets("JSON Viewer can show error message", (WidgetTester tester) async {
    const view = JsonBeautifyView();
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(size: Size(500, 300)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MaterialApp(
            home: Scaffold(
              body: view,
            ),
          ),
        ),
      ),
    );

    var errorFinder = find.byKey(const Key("errorKey"));
    expect(errorFinder, findsNothing, reason: "Error is not yet shown");
  });
}
