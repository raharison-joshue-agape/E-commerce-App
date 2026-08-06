import 'package:e_commerce_app/core/errors/product_not_found_exception.dart';
import 'package:e_commerce_app/features/products/providers/product_reviews_providers.dart';
import 'package:e_commerce_app/features/products/providers/products_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('productsProvider starts in loading state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(productsProvider),
      isA<AsyncLoading<List<dynamic>>>(),
    );
  });

  test('productsProvider emits the product list after loading', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final products = await container.read(productsProvider.future);

    expect(products, isNotEmpty);
    expect(products.first.name, isNotEmpty);
    expect(products.first.price, greaterThan(0));
  });

  test('productDetailProvider returns the product for a valid id', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final product = await container.read(
      productDetailProvider('iphone-15-pro').future,
    );

    expect(product.name, 'iPhone 15 Pro');
    expect(product.specifications, isNotEmpty);
  });

  test('productDetailProvider throws for an unknown id', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await expectLater(
      container.read(productDetailProvider('unknown-id').future),
      throwsA(isA<ProductNotFoundException>()),
    );
  });

  test(
    'relatedProductsProvider prefers products of the same category',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final related = await container.read(
        relatedProductsProvider('iphone-15-pro').future,
      );

      expect(related, isNotEmpty);
      expect(related.first.category, 'Smartphones');
      expect(related.any((product) => product.id == 'iphone-15-pro'), isFalse);
    },
  );

  test('productReviewsProvider returns reviews for a product', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final reviews = await container.read(
      productReviewsProvider('iphone-15-pro').future,
    );

    expect(reviews, isNotEmpty);
    expect(reviews.every((review) => review.comment.isNotEmpty), isTrue);
  });
}
