import 'package:flutter_test/flutter_test.dart';
import 'package:pks5/main.dart';

void main() {
  testWidgets('App should build properly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

  });
}
