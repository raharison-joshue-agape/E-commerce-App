import 'package:e_commerce_app/app/app.dart';
import 'package:e_commerce_app/features/cart/providers/cart_providers.dart';
import 'package:e_commerce_app/features/cart/widgets/cart_badge.dart';
import 'package:e_commerce_app/features/products/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const iphone = _Product(
    id: 'iphone-15-pro',
    name: 'iPhone 15 Pro',
    price: 1299,
  );

  testWidgets('CartBadge hides when the cart is empty and shows the count', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(body: CartBadge(onPressed: () {})),
        ),
      ),
    );

    expect(find.text('1'), findsNothing);

    container.read(cartProvider.notifier).addProduct(iphone);
    await tester.pump();

    expect(find.text('1'), findsOneWidget);

    container.read(cartProvider.notifier).removeProduct(iphone.id);
    await tester.pump();

    expect(find.text('1'), findsNothing);
  });

  testWidgets('the app bar and navigation bar badges update automatically', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ECommerceApp(),
      ),
    );

    final appBarFinder = find.byType(AppBar);
    final navBarFinder = find.byType(NavigationBar);

    expect(
      find.descendant(of: appBarFinder, matching: find.text('1')),
      findsNothing,
    );
    expect(
      find.descendant(of: navBarFinder, matching: find.text('1')),
      findsNothing,
    );

    container.read(cartProvider.notifier).addProduct(iphone);
    await tester.pump();

    expect(
      find.descendant(of: appBarFinder, matching: find.text('1')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: navBarFinder, matching: find.text('1')),
      findsOneWidget,
    );

    container.read(cartProvider.notifier).clearCart();
    await tester.pump();

    expect(
      find.descendant(of: appBarFinder, matching: find.text('1')),
      findsNothing,
    );
    expect(
      find.descendant(of: navBarFinder, matching: find.text('1')),
      findsNothing,
    );

    await tester.pump(const Duration(seconds: 1));
  });
}

class _Product extends Product {
  const _Product({required super.id, required super.name, required super.price})
    : super(
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
