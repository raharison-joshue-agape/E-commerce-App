import 'package:e_commerce_app/features/cart/providers/cart_providers.dart';
import 'package:e_commerce_app/features/products/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const iphone = _Product(id: 'iphone', name: 'iPhone', price: 1299);
  const macbook = _Product(id: 'macbook', name: 'MacBook', price: 1199);

  test('cart starts empty', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(cartProvider);

    expect(state.isEmpty, isTrue);
    expect(state.items, isEmpty);
    expect(state.itemCount, 0);
    expect(state.subtotal, 0);
    expect(state.total, 0);
  });

  test('addProduct adds a product with quantity one', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(cartProvider.notifier);

    notifier.addProduct(iphone);

    final state = container.read(cartProvider);
    expect(state.isEmpty, isFalse);
    expect(state.itemCount, 1);
    expect(state.items.single.productId, iphone.id);
    expect(notifier.containsProduct(iphone.id), isTrue);
    expect(notifier.getQuantity(iphone.id), 1);
  });

  test('adding the same product does not create duplicates', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(cartProvider.notifier);

    notifier.addProduct(iphone);
    notifier.addProduct(iphone);

    final state = container.read(cartProvider);
    expect(state.items.length, 1);
    expect(state.itemCount, 2);
    expect(notifier.getQuantity(iphone.id), 2);
    expect(state.subtotal, closeTo(1299 * 2, 0.001));
  });

  test('addProduct adds distinct products as separate items', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(cartProvider.notifier);

    notifier.addProduct(iphone);
    notifier.addProduct(macbook);

    final state = container.read(cartProvider);
    expect(state.items.length, 2);
    expect(state.itemCount, 2);
  });

  test('increaseQuantity increments the quantity', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(cartProvider.notifier);

    notifier.addProduct(iphone);
    notifier.increaseQuantity(iphone.id);

    expect(notifier.getQuantity(iphone.id), 2);
    expect(container.read(cartProvider).itemCount, 2);
  });

  test('decreaseQuantity decrements the quantity', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(cartProvider.notifier);

    notifier.addProduct(iphone);
    notifier.increaseQuantity(iphone.id);
    notifier.decreaseQuantity(iphone.id);

    expect(notifier.getQuantity(iphone.id), 1);
  });

  test('decreaseQuantity never goes below one', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(cartProvider.notifier);

    notifier.addProduct(iphone);
    notifier.decreaseQuantity(iphone.id);
    notifier.decreaseQuantity(iphone.id);

    expect(notifier.getQuantity(iphone.id), 1);
    expect(container.read(cartProvider).itemCount, 1);
  });

  test('removeProduct removes the product from the cart', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(cartProvider.notifier);

    notifier.addProduct(iphone);
    notifier.addProduct(macbook);
    notifier.removeProduct(iphone.id);

    final state = container.read(cartProvider);
    expect(state.items.length, 1);
    expect(state.items.single.productId, macbook.id);
    expect(notifier.containsProduct(iphone.id), isFalse);
  });

  test('removeProduct for an unknown id is safe', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(cartProvider.notifier);

    notifier.addProduct(iphone);
    notifier.removeProduct('unknown-id');

    expect(container.read(cartProvider).itemCount, 1);
  });

  test('clearCart empties the cart', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(cartProvider.notifier);

    notifier.addProduct(iphone);
    notifier.addProduct(macbook);
    notifier.clearCart();

    final state = container.read(cartProvider);
    expect(state.isEmpty, isTrue);
    expect(state.itemCount, 0);
    expect(state.subtotal, 0);
  });

  test('totals are computed automatically', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(cartProvider.notifier);

    notifier.addProduct(iphone);
    notifier.addProduct(macbook);
    notifier.increaseQuantity(iphone.id);

    final state = container.read(cartProvider);
    expect(state.itemCount, 3);
    expect(state.subtotal, closeTo(1299 * 2 + 1199, 0.001));
    expect(state.total, closeTo(state.subtotal, 0.001));
  });

  test('getQuantity returns zero for an unknown id', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(cartProvider.notifier).getQuantity('unknown-id'),
      0,
    );
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
         category: 'Test',
         brand: 'Test',
         oldPrice: null,
         discount: null,
         rating: 4.5,
         reviewCount: 1,
         stock: 10,
         isAvailable: true,
         colors: const [],
         sizes: const [],
         images: const [],
         specifications: const {},
       );
}
