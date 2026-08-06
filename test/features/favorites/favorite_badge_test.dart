import 'package:e_commerce_app/app/app.dart';
import 'package:e_commerce_app/features/favorites/providers/favorites_providers.dart';
import 'package:e_commerce_app/features/favorites/widgets/favorite_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('FavoriteBadge hides when empty and shows the count', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: FavoriteBadge(selected: false)),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('1'), findsNothing);

    final notifier = container.read(favoritesProvider.notifier);
    await notifier.addFavorite('iphone-15-pro');
    await tester.pump();

    expect(find.text('1'), findsOneWidget);

    await notifier.addFavorite('airpods-pro-2');
    await tester.pump();

    expect(find.text('2'), findsOneWidget);

    await notifier.removeFavorite('iphone-15-pro');
    await notifier.removeFavorite('airpods-pro-2');
    await tester.pump();

    expect(find.text('1'), findsNothing);
    expect(find.text('2'), findsNothing);
  });

  testWidgets('the navigation bar badge updates automatically', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ECommerceApp(),
      ),
    );
    await tester.pump();

    final navBarFinder = find.byType(NavigationBar);

    expect(
      find.descendant(of: navBarFinder, matching: find.text('1')),
      findsNothing,
    );

    final notifier = container.read(favoritesProvider.notifier);
    await notifier.addFavorite('iphone-15-pro');
    await tester.pump();

    expect(
      find.descendant(of: navBarFinder, matching: find.text('1')),
      findsOneWidget,
    );

    await notifier.addFavorite('macbook-air-m3');
    await tester.pump();

    expect(
      find.descendant(of: navBarFinder, matching: find.text('2')),
      findsOneWidget,
    );

    await notifier.removeFavorite('iphone-15-pro');
    await notifier.removeFavorite('macbook-air-m3');
    await tester.pump();

    expect(
      find.descendant(of: navBarFinder, matching: find.text('1')),
      findsNothing,
    );
    expect(
      find.descendant(of: navBarFinder, matching: find.text('2')),
      findsNothing,
    );

    await tester.pump(const Duration(seconds: 1));
  });
}
