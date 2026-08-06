import 'package:e_commerce_app/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the home page with the bottom navigation', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: ECommerceApp()));

    expect(find.text('NovaShop'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Accueil'), findsOneWidget);
    expect(find.text('Produits'), findsOneWidget);
    expect(find.text('Favoris'), findsOneWidget);
    expect(find.text('Panier'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
  });
}
