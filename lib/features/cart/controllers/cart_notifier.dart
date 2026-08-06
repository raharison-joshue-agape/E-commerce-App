import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../products/models/product.dart';
import '../models/cart_item.dart';

class CartState {
  CartState({List<CartItem> items = const []})
    : _items = List.unmodifiable(items);

  final List<CartItem> _items;

  List<CartItem> get items => _items;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);

  double get total => subtotal;

  bool get isEmpty => items.isEmpty;

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => CartState();

  void addProduct(Product product) {
    if (containsProduct(product.id)) {
      increaseQuantity(product.id);
      return;
    }
    final items = [...state.items, CartItem(product: product)];
    state = state.copyWith(items: items);
  }

  void removeProduct(String productId) {
    state = state.copyWith(
      items: state.items
          .where((item) => item.productId != productId)
          .toList(),
    );
  }

  void increaseQuantity(String productId) {
    state = state.copyWith(
      items: state.items
          .map(
            (item) => item.productId == productId
                ? item.copyWith(quantity: item.quantity + 1)
                : item,
          )
          .toList(),
    );
  }

  void decreaseQuantity(String productId) {
    state = state.copyWith(
      items: state.items
          .map(
            (item) => item.productId == productId
                ? item.copyWith(quantity: _decrement(item.quantity))
                : item,
          )
          .toList(),
    );
  }

  void clearCart() => state = CartState();

  bool containsProduct(String productId) {
    return state.items.any((item) => item.productId == productId);
  }

  int getQuantity(String productId) {
    for (final item in state.items) {
      if (item.productId == productId) return item.quantity;
    }
    return 0;
  }

  int _decrement(int quantity) => quantity > 1 ? quantity - 1 : 1;
}
