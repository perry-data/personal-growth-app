import 'package:flutter_test/flutter_test.dart';

import 'package:personal_growth_app/main.dart' as app;

void main() {
  test('ymd formats date as YYYY-MM-DD', () {
    expect(app.ymd(DateTime(2026, 1, 8)), '2026-01-08');
  });
}
