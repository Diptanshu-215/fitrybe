import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fitrybe/main.dart';

void main() {
  testWidgets('Welcome screen elements smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FitrybeApp());

    // Verify that the brand SVG logo mark and wordmark are shown.
    expect(find.byType(SvgPicture), findsNWidgets(2));

    // Verify that the welcome messaging is shown.
    expect(find.text('MOVE'), findsOneWidget);
    expect(find.text('TOGETHER'), findsOneWidget);

    // Verify that onboarding buttons exist.
    expect(find.text('Join Us'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });
}
