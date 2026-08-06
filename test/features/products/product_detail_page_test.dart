import 'package:e_commerce_app/features/products/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProductDetailPage shows the full product information', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProductDetailPage(productId: 'iphone-15-pro'),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    expect(find.text('Apple'), findsWidgets);
    expect(find.text('1 299,00 €'), findsOneWidget);
    expect(find.text('1 399,00 €'), findsOneWidget);
    expect(find.text('-10%'), findsAtLeastNWidgets(1));
    expect(find.text('En stock'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Caractéristiques'), findsOneWidget);
    expect(find.text('Couleurs'), findsOneWidget);
    expect(find.text('Écran'), findsOneWidget);
    expect(find.text('Avis clients'), findsOneWidget);
    expect(find.text('Produits similaires'), findsOneWidget);

    expect(find.text('Ajouter au panier'), findsOneWidget);
    expect(find.text('Acheter maintenant'), findsOneWidget);
  });

  testWidgets('ProductDetailPage shows a not found view for an unknown id', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ProductDetailPage(productId: 'unknown-id'),
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Produit introuvable'), findsOneWidget);
    expect(find.text('Retour au catalogue'), findsOneWidget);
  });
}
