import 'package:e_commerce_app/features/products/pages/product_list_page.dart';
import 'package:e_commerce_app/features/products/widgets/empty_search_widget.dart';
import 'package:e_commerce_app/shared/widgets/app_skeletons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpListPage(WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ProductListPage())),
    );
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('ProductListPage shows loading then the product grid', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ProductListPage())),
    );

    expect(find.byType(ProductCardSkeleton), findsWidgets);

    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(ProductCardSkeleton), findsNothing);
    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    expect(find.text('1 299,00 €'), findsOneWidget);
  });

  testWidgets('searching filters the grid in real time', (tester) async {
    await pumpListPage(tester);

    expect(find.text('MacBook Air M3'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'iphone');
    await tester.pumpAndSettle();

    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    expect(find.text('MacBook Air M3'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    expect(find.text('MacBook Air M3'), findsOneWidget);
  });

  testWidgets('category chips filter the grid', (tester) async {
    await pumpListPage(tester);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Gaming'));
    await tester.pumpAndSettle();

    expect(find.text('PlayStation 5'), findsOneWidget);
    expect(find.text('Xbox Series X'), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Tous'));
    await tester.pumpAndSettle();

    expect(find.text('iPhone 15 Pro'), findsOneWidget);
  });

  testWidgets(
    'an empty result shows the empty search state and reset restores the list',
    (tester) async {
      await pumpListPage(tester);

      await tester.enterText(find.byType(TextField), 'zzzzz');
      await tester.pumpAndSettle();

      expect(find.byType(EmptySearchWidget), findsOneWidget);
      expect(find.text('Aucun produit trouvé'), findsOneWidget);
      expect(
        find.text('Essayez de modifier vos critères de recherche.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Réinitialiser les filtres'));
      await tester.pumpAndSettle();

      expect(find.byType(EmptySearchWidget), findsNothing);
      expect(find.text('iPhone 15 Pro'), findsOneWidget);
    },
  );

  testWidgets('the grid is responsive and stays usable on narrow screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpListPage(tester);

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(SearchBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
