// Basic smoke test: verifies the app boots to the splash screen without
// throwing, using the same ProviderScope + MockData bootstrap as main().

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kast_rolz/main.dart';
import 'package:kast_rolz/shared/mock/mock_data.dart';

void main() {
  testWidgets('KastRolzApp boots to splash screen', (WidgetTester tester) async {
    MockData.init();

    await tester.pumpWidget(const ProviderScope(child: KastRolzApp()));
    await tester.pump();

    expect(find.text('KAST-ROLZ'), findsWidgets);

    // Let the splash screen's handoff timer and entrance animations finish
    // so no timers are left pending when the test tears down.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));
  });
}
