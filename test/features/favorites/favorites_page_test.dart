import 'package:e_commerce_app/core/constants/app_routes.dart';
import 'package:e_commerce_app/features/favorites/datasource/favorites_local_datasource.dart';
import 'package:e_commerce_app/features/favorites/pages/favorites_page.dart';
import 'package:e_commerce_app/features/favorites/providers/favorites_providers.dart';
import 'package:e_commerce_app/features/favorites/widgets/empty_favorites_widget.dart';
import 'package:e_commerce_app/features/favorites/widgets/favorite_card.dart';
import 'package:e_commerce_app/features/favorites/widgets/favorite_grid.dart';
import 'package:e_commerce_app/features/products/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpPage(WidgetTester tester, ProviderContainer container) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: FavoritesPage()),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('shows the empty state when there are no favorites', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await pumpPage(tester, container);

    expect(find.byType(EmptyFavoritesWidget), findsOneWidget);
    expect(find.text('Aucun favori'), findsOneWidget);
    expect(
      find.text('Ajoutez des produits à vos favoris pour les retrouver facilement.'),
      findsOneWidget,
    );
    expect(find.text('Découvrir les produits'), findsOneWidget);
    expect(find.byType(FavoriteGrid), findsNothing);
  });

  testWidgets('the empty state navigates back to the catalogue', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: AppRoutes.favorites,
      routes: [
        GoRoute(
          path: AppRoutes.favorites,
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(
          path: AppRoutes.products,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('CATALOGUE')),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('Découvrir les produits'));
    await tester.pumpAndSettle();

    expect(find.text('CATALOGUE'), findsOneWidget);
  });

  testWidgets('shows the favorited products with price and rating', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'favorite_products': ['iphone-15-pro', 'airpods-pro-2'],
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await pumpPage(tester, container);

    expect(find.byType(FavoriteGrid), findsOneWidget);
    expect(find.byType(FavoriteCard), findsNWidgets(2));
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    expect(find.text('1 299,00 €'), findsOneWidget);
    expect(find.text('4.8'), findsOneWidget);
    expect(find.text('AirPods Pro 2'), findsOneWidget);
    expect(find.text('249,00 €'), findsOneWidget);
  });

  testWidgets('removing a favorite updates the grid and shows a snackbar', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'favorite_products': ['iphone-15-pro'],
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await pumpPage(tester, container);

    expect(find.byType(FavoriteCard), findsOneWidget);

    await tester.tap(find.byTooltip('Retirer des favoris'));
    await tester.pumpAndSettle();

    expect(find.byType(FavoriteCard), findsNothing);
    expect(find.byType(EmptyFavoritesWidget), findsOneWidget);
    expect(find.text('Produit retiré des favoris'), findsOneWidget);
    expect(container.read(favoritesProvider).isEmpty, isTrue);
  });

  testWidgets('tapping a favorite navigates to the product detail page', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'favorite_products': ['iphone-15-pro'],
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: AppRoutes.favorites,
      routes: [
        GoRoute(
          path: AppRoutes.favorites,
          builder: (context, state) => const FavoritesPage(),
        ),
        GoRoute(
          path: AppRoutes.productDetail,
          builder: (context, state) => ProductDetailPage(
            productId: state.pathParameters['id'] ?? '',
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('iPhone 15 Pro'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Ajouter au panier'), findsOneWidget);
    expect(find.text('Acheter maintenant'), findsOneWidget);
  });

  testWidgets('shows an error view when loading fails and retry recovers', (
    tester,
  ) async {
    final datasource = _FlakyFavoritesLocalDataSource();
    final container = ProviderContainer(
      overrides: [
        favoritesLocalDataSourceProvider.overrideWithValue(datasource),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: FavoritesPage()),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Impossible de charger vos favoris.'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);

    await tester.tap(find.text('Réessayer'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(EmptyFavoritesWidget), findsOneWidget);
  });
}

class _FlakyFavoritesLocalDataSource implements FavoritesLocalDataSource {
  int _readCount = 0;

  @override
  Future<List<String>> readFavoriteIds() async {
    _readCount++;
    if (_readCount == 1) {
      throw Exception('Cannot read shared preferences');
    }
    return const [];
  }

  @override
  Future<void> writeFavoriteIds(List<String> ids) async {}
}
