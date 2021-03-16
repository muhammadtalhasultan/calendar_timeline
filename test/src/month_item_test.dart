
import 'package:calendar_timeline/src/month_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MaterialApp app = MaterialApp(
    home: Scaffold(
      body:  MonthItem(
        name: 'month',
        onTap: () => print('onTap'),
      )
    ),
  );
  testWidgets('MonthItem has name text in uppercase', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    expect(find.text('MONTH'), findsOneWidget);
  });
}