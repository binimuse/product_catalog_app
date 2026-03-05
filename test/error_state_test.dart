import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test_app/app/design_system/components/error_state.dart';

void main() {
  group('ErrorState', () {
    testWidgets('displays message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorState(message: 'Network error'),
          ),
        ),
      );
      expect(find.text('Network error'), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorState(
              message: 'Error',
              onRetry: () {},
            ),
          ),
        ),
      );
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('calls onRetry when retry button tapped', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorState(
              message: 'Error',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(retried, isTrue);
    });
  });
}
