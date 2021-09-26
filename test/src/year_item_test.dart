import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

import '../helper/helper.dart';
import '../test_utils/test_utils.dart';

void main() {
  MaterialApp app = MaterialApp(
    home: Scaffold(
        body: YearItem(
      name: 'year',
      onTap: () => print('onTap'),
    )),
  );
  testWidgets('YearItem has name text in uppercase',
      (WidgetTester tester) async {
    await tester.pumpWidget(app);
    expect(find.text('YEAR'), findsOneWidget);
  });

  group(
    'YearItem',
    () {
      group(
        'Render',
        () {
          testWidgets(
            'name text in uppercase',
            (WidgetTester tester) async {
              await tester.pumpApp(
                YearItem(
                  name: ParamFactory.yearName,
                  onTap: () {},
                ),
              );

              final widget = find.text(ParamFactory.yearName.toUpperCase());
              expect(widget, findsOneWidget);
            },
          );
        },
      );
      group(
        'Style',
        () {
          testWidgets(
            'if widget have [isSelected] or [small] to true value, add'
            'a box decoration',
            (WidgetTester tester) async {
              await tester.pumpApp(
                YearItem(
                  name: ParamFactory.yearName,
                  small: ParamFactory.isSmall,
                  onTap: () {},
                ),
              );

              final decoration = BoxDecoration(
                border: Border.all(color: Colors.black87, width: 1),
                borderRadius: BorderRadius.circular(4),
              );
              var widget = find.byWidgetPredicate(
                (widget) => ParamFactory.isContainerWithDecoration(
                  widget,
                  decoration,
                ),
              );
              expect(widget, findsOneWidget);

              await tester.pumpApp(
                YearItem(
                  name: ParamFactory.yearName,
                  small: ParamFactory.isNotSmall,
                  onTap: () {},
                ),
              );

              widget = find.byWidgetPredicate(
                (widget) => ParamFactory.isContainerWithDecoration(
                  widget,
                  decoration,
                ),
              );
              expect(widget, findsNothing);
            },
          );
          testWidgets(
            'text size change according to [small] field value',
            (WidgetTester tester) async {
              await tester.pumpApp(
                YearItem(
                  name: ParamFactory.yearName,
                  small: ParamFactory.isSmall, // default value
                  onTap: () {},
                ),
              );

              var widget = find.byWidgetPredicate(
                (widget) => ParamFactory.isTextWithFontSize(
                  widget,
                  ParamFactory.smallTextSize,
                ),
              );
              expect(widget, findsOneWidget);

              await tester.pumpApp(
                YearItem(
                  name: ParamFactory.yearName,
                  small: ParamFactory.isNotSmall,
                  onTap: () {},
                ),
              );

              widget = find.byWidgetPredicate(
                (widget) => ParamFactory.isTextWithFontSize(
                  widget,
                  ParamFactory.smallTextSize,
                ),
              );
              expect(widget, findsNothing);
            },
          );
        },
      );
      group(
        'Call',
        () {
          testWidgets(
            '[onTap] callback when widget is tapped and it is not small',
            (WidgetTester tester) async {
              var functionCalls = 0;
              final onTap = () => functionCalls++;

              await tester.pumpApp(
                YearItem(
                  name: ParamFactory.yearName,
                  small: ParamFactory.isNotSmall,
                  onTap: onTap,
                ),
              );
              expect(functionCalls, isZero);

              final widget = find.text(ParamFactory.yearName.toUpperCase());
              await tester.tap(widget);
              expect(functionCalls, 1);
            },
          );
          testWidgets(
            '[onTap] is not called when widget is tapped and it is small',
                (WidgetTester tester) async {
              var functionCalls = 0;
              final onTap = () => functionCalls++;

              await tester.pumpApp(
                YearItem(
                  name: ParamFactory.yearName,
                  small: ParamFactory.isSmall,
                  onTap: onTap,
                ),
              );
              expect(functionCalls, isZero);

              final widget = find.text(ParamFactory.yearName.toUpperCase());
              await tester.tap(widget);
              expect(functionCalls, isZero);
            },
          );
        },
      );
    },
  );
}
