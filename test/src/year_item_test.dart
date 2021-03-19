
import 'package:calendar_timeline/src/year_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MaterialApp app = MaterialApp(
    home: Scaffold(
      body:  YearItem(
        name: 'year',
        onTap: () => print('onTap'),
      )
    ),
  );
  testWidgets('YearItem has name text in uppercase', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    expect(find.text('YEAR'), findsOneWidget);
  });
}