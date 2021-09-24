import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

void main() {
  MaterialApp app = MaterialApp(
    home: Scaffold(
        body: DayItem(
      dayNumber: 1,
      shortName: 'ASD',
      isSelected: true,
      onTap: () => print('onTap'),
    )),
  );
  testWidgets('DayItem has a day and name text', (WidgetTester tester) async {
    await tester.pumpWidget(app);
    final day = find.text('1');
    final name = find.text('ASD');
    expect(day, findsOneWidget);
    expect(name, findsOneWidget);
  });
}
