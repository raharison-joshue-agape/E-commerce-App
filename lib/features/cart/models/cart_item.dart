import '../../products/models/product.dart';

class CartItem {
  const CartItem({required this.product, this.quantity = 1})
    : assert(quantity >= 1);

  final Product product;
  final int quantity;

  String get productId => product.id;

  double get subtotal => product.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }
}
