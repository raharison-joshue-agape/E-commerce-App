import 'package:e_commerce_app/features/favorites/providers/favorites_providers.dart';
import 'package:e_commerce_app/features/products/pages/product_detail_page.dart';
import 'package:e_commerce_app/features/products/pages/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('toggling from the detail page updates the favorites state', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ProductDetailPage(productId: 'iphone-15-pro'),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byTooltip('Ajouter aux favoris'));
    await tester.pumpAndSettle();

    expect(find.text('Produit ajouté aux favoris'), findsOneWidget);
    expect(
      container.read(favoritesProvider).isFavorite('iphone-15-pro'),
      isTrue,
    );

    await tester.tap(find.byTooltip('Retirer des favoris'));
    await tester.pumpAndSettle();

    expect(find.text('Produit retiré des favoris'), findsOneWidget);
    expect(
      container.read(favoritesProvider).isFavorite('iphone-15-pro'),
      isFalse,
    );
  });

  testWidgets('product cards stay in sync with the favorites state', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ProductListPage()),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.byIcon(Icons.favorite), findsNothing);
    expect(find.byIcon(Icons.favorite_border), findsWidgets);

    final notifier = container.read(favoritesProvider.notifier);
    await notifier.addFavorite('iphone-15-pro');
    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsOneWidget);

    await notifier.removeFavorite('iphone-15-pro');
    await tester.pump();

    expect(find.byIcon(Icons.favorite), findsNothing);
  });
}
