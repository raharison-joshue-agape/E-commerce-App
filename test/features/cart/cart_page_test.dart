import 'package:e_commerce_app/core/constants/app_routes.dart';
import 'package:e_commerce_app/features/cart/pages/cart_page.dart';
import 'package:e_commerce_app/features/cart/providers/cart_providers.dart';
import 'package:e_commerce_app/features/cart/widgets/cart_item_card.dart';
import 'package:e_commerce_app/features/cart/widgets/cart_summary.dart';
import 'package:e_commerce_app/features/cart/widgets/checkout_bar.dart';
import 'package:e_commerce_app/features/cart/widgets/empty_cart_widget.dart';
import 'package:e_commerce_app/features/products/models/product.dart';
import 'package:e_commerce_app/features/products/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  const iphone = _Product(
    id: 'iphone-15-pro',
    name: 'iPhone 15 Pro',
    price: 1299,
  );

  ProviderContainer createContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  void addToCart(ProviderContainer container, Product product, {int times = 1}) {
    final notifier = container.read(cartProvider.notifier);
    for (var i = 0; i < times; i++) {
      notifier.addProduct(product);
    }
  }

  testWidgets('CartPage shows the empty state when the cart is empty', (
    tester,
  ) async {
    final container = createContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: CartPage()),
      ),
    );

    expect(find.byType(EmptyCartWidget), findsOneWidget);
    expect(find.text('Votre panier est vide.'), findsOneWidget);
    expect(find.text('Continuer vos achats'), findsOneWidget);
    expect(find.byType(CartSummary), findsNothing);
    expect(find.byType(CheckoutBar), findsNothing);
  });

  testWidgets('empty cart navigates to the catalogue', (tester) async {
    final container = createContainer();
    final router = GoRouter(
      initialLocation: AppRoutes.cart,
      routes: [
        GoRoute(
          path: AppRoutes.cart,
          builder: (context, state) => const CartPage(),
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

    await tester.tap(find.text('Continuer vos achats'));
    await tester.pumpAndSettle();

    expect(find.text('CATALOGUE'), findsOneWidget);
  });

  testWidgets('CartPage shows items, quantities and totals', (tester) async {
    final container = createContainer();
    addToCart(container, iphone);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: CartPage()),
      ),
    );

    expect(find.byType(CartItemCard), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.byType(CartSummary), findsOneWidget);
    expect(find.text('Nombre d\'articles'), findsOneWidget);
    expect(find.text('Sous-total'), findsOneWidget);
    expect(find.text('Livraison'), findsOneWidget);
    expect(find.text('Gratuite'), findsOneWidget);
    expect(find.text('Total'), findsWidgets);
    expect(find.byType(CheckoutBar), findsOneWidget);
  });

  testWidgets('increasing the quantity updates subtotal and total', (
    tester,
  ) async {
    final container = createContainer();
    addToCart(container, iphone);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: CartPage()),
      ),
    );

    expect(find.text('1 299,00 €'), findsNWidgets(5));

    await tester.tap(find.byTooltip('Augmenter la quantité'));
    await tester.pumpAndSettle();

    expect(find.text('2 598,00 €'), findsNWidgets(4));
    expect(find.text('1 299,00 €'), findsOneWidget);
    expect(container.read(cartProvider.notifier).getQuantity(iphone.id), 2);
  });

  testWidgets('decreasing the quantity updates totals and never goes below one', (
    tester,
  ) async {
    final container = createContainer();
    addToCart(container, iphone, times: 2);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: CartPage()),
      ),
    );

    await tester.tap(find.byTooltip('Diminuer la quantité'));
    await tester.pumpAndSettle();

    expect(container.read(cartProvider.notifier).getQuantity(iphone.id), 1);
    expect(find.text('1 299,00 €'), findsNWidgets(5));

    final minusButton = tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.remove),
        matching: find.byType(IconButton),
      ),
    );
    expect(minusButton.onPressed, isNull);
  });

  testWidgets('deleting a product removes it from the cart', (tester) async {
    final container = createContainer();
    addToCart(container, iphone);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: CartPage()),
      ),
    );

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.byType(CartItemCard), findsNothing);
    expect(find.text('Votre panier est vide.'), findsOneWidget);
    expect(container.read(cartProvider).isEmpty, isTrue);
  });

  testWidgets('clearing the cart requires confirmation', (tester) async {
    final container = createContainer();
    addToCart(container, iphone);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: CartPage()),
      ),
    );

    await tester.tap(find.text('Vider'));
    await tester.pumpAndSettle();

    expect(find.text('Vider le panier'), findsOneWidget);
    expect(find.text('Voulez-vous vraiment retirer tous les articles ?'), findsOneWidget);
    expect(find.text('Annuler'), findsOneWidget);
    expect(find.text('Oui'), findsOneWidget);

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    expect(container.read(cartProvider).isEmpty, isFalse);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);

    await tester.tap(find.text('Vider'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Oui'));
    await tester.pumpAndSettle();

    expect(container.read(cartProvider).isEmpty, isTrue);
    expect(find.text('Votre panier est vide.'), findsOneWidget);
  });

  testWidgets('CartPage is responsive on narrow screens', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final container = createContainer();
    addToCart(container, iphone, times: 2);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: CartPage()),
      ),
    );

    expect(find.byType(CartItemCard), findsOneWidget);
    expect(find.byType(CheckoutBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adding a product from the detail page updates the cart', (
    tester,
  ) async {
    final container = createContainer();

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

    await tester.tap(find.text('Ajouter au panier'));
    await tester.pump();

    expect(find.text('Produit ajouté au panier.'), findsOneWidget);
    expect(container.read(cartProvider).itemCount, 1);
    expect(container.read(cartProvider.notifier).getQuantity(iphone.id), 1);

    await tester.tap(find.text('Ajouter au panier'));
    await tester.pump();

    expect(container.read(cartProvider).itemCount, 2);
    expect(container.read(cartProvider.notifier).getQuantity(iphone.id), 2);
  });
}

class _Product extends Product {
  const _Product({
    required super.id,
    required super.name,
    required super.price,
  }) : super(
         description: '',
         shortDescription: '',
         imageUrl: '',
         category: 'Smartphones',
         brand: 'Apple',
         oldPrice: null,
         discount: null,
         rating: 4.8,
         reviewCount: 352,
         stock: 25,
         isAvailable: true,
         colors: const [],
         sizes: const [],
         images: const [],
         specifications: const {},
       );
}
