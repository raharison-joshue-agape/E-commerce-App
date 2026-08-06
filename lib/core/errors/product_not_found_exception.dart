class ProductNotFoundException implements Exception {
  const ProductNotFoundException(this.productId);

  final String productId;

  @override
  String toString() => 'Produit introuvable : $productId';
}
