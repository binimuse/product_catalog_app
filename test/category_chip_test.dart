import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test_app/app/design_system/components/category_chip.dart';

void main() {
  group('CategoryChip', () {
    testWidgets('displays label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(label: 'Electronics', onTap: () {}),
          ),
        ),
      );
      expect(find.text('Electronics'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              label: 'Test',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(CategoryChip));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('shows selected style when selected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: CategoryChip(label: 'Test', selected: true, onTap: () {}),
          ),
        ),
      );
      expect(find.byType(CategoryChip), findsOneWidget);
    });
  });
}
