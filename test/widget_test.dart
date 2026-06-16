import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saihae_project/app/app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'app_settings': '{"onboardingCompleted":true,"disclaimerAccepted":true}',
    });
  });

  testWidgets('SaihaeApp renders the main tab smoke screen', (tester) async {
    await tester.pumpWidget(const SaihaeApp());
    await tester.pumpAndSettle();

    expect(find.text('사이해'), findsOneWidget);
    expect(find.text('홈'), findsOneWidget);
    expect(find.text('나 분석'), findsOneWidget);
    expect(find.text('관계'), findsOneWidget);
    expect(find.text('기록'), findsOneWidget);
  });
}
