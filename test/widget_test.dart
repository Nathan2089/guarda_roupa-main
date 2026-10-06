import 'package:flutter_test/flutter_test.dart';
import 'package:guarda_roupa/main.dart';

void main() {
  testWidgets('WardrobeApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WardrobeApp());

    // Verify that the app title or logo text renders
    expect(find.text('WardrobeAI'), findsWidgets);
  });
}
