import 'package:e_commerce_app/features/products/pages/home_page.dart';
import 'package:e_commerce_app/features/products/widgets/category_card.dart';
import 'package:e_commerce_app/features/products/widgets/home_banner.dart';
import 'package:e_commerce_app/features/products/widgets/product_card.dart';
import 'package:e_commerce_app/features/products/widgets/promotion_card.dart';
import 'package:e_commerce_app/features/products/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomePage shows the main sections', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    expect(find.text('NovaShop'), findsOneWidget);
    expect(find.byType(HomeBanner), findsOneWidget);
    expect(find.text('Découvrez les meilleures offres du moment'), findsOneWidget);
    expect(find.text('Découvrir'), findsOneWidget);
    expect(find.byType(SectionTitle), findsWidgets);
    expect(find.text('Catégories'), findsOneWidget);
    expect(find.byType(CategoryCard), findsWidgets);
    expect(find.text('Produits populaires'), findsOneWidget);
    expect(find.text('Offres du jour'), findsOneWidget);
    expect(find.byType(PromotionCard), findsOneWidget);
    expect(find.text('Merci de visiter notre boutique.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(ProductCard), findsWidgets);
  });
}
