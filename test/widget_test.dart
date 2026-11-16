import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_treasure/features/treasures/domain/entities/category_entity.dart';
import 'package:tech_treasure/features/treasures/presentation/providers/treasure_providers.dart';
import 'package:tech_treasure/main.dart';

void main() {
  testWidgets('App launches and renders Dashboard and Bottom Navigation', (WidgetTester tester) async {
    final testCategories = [
      CategoryEntity(
        id: 'cat_phone_tricks',
        name: 'Phone Tricks',
        icon: 'smartphone',
        createdAt: DateTime.now(),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoriesStreamProvider.overrideWith((ref) => Stream.value(testCategories)),
          statusCountsStreamProvider.overrideWith((ref) => Stream.value({})),
          treasuresStreamProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const TechTreasureApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Dashboard header and Tech Treasure title
    expect(find.text('Tech Treasure'), findsOneWidget);
    expect(find.text('Good day 👋'), findsOneWidget);

    // Verify Bottom Navigation items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Treasures'), findsOneWidget);
    expect(find.text('Pipeline'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Verify Quick Capture Floating Action Button
    expect(find.byKey(const Key('fab_quick_capture')), findsOneWidget);

    // Tap on Quick Capture and verify bottom sheet opens
    await tester.tap(find.byKey(const Key('fab_quick_capture')));
    await tester.pumpAndSettle();

    expect(find.text('Quick Capture Discovery'), findsOneWidget);
    expect(find.byKey(const Key('input_treasure_title')), findsOneWidget);
    expect(find.byKey(const Key('btn_quick_save')), findsOneWidget);

    // Close bottom sheet
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
  });
}
