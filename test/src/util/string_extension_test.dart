
import 'package:calendar_timeline/src/util/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('String capitalize function would convert first character to uppercase', () {
    final string = 'string';
    expect(string.capitalize(), 'String');
  });
}