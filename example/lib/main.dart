import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CalendarTimeline(
          initialDate: DateTime.now(),
          firstDate: DateTime(2019, 1, 1),
          lastDate: DateTime(2020, 12, 31),
          onDateSelected: (date) => print(date),
          leftMargin: 20,
        ),
      )
    );
  }
}

