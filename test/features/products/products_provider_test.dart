import 'package:e_commerce_app/features/products/providers/products_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('productsProvider starts in loading state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(productsProvider), isA<AsyncLoading<List<dynamic>>>());
  });

  test('productsProvider emits the product list after loading', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final products = await container.read(productsProvider.future);

    expect(products, isNotEmpty);
    expect(products.first.name, isNotEmpty);
    expect(products.first.price, greaterThan(0));
  });
}
