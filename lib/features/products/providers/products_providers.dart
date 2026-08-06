import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasource/mock_product_datasource.dart';
import '../datasource/product_datasource.dart';
import '../models/product.dart';
import '../repository/product_repository.dart';
import '../repository/product_repository_impl.dart';

const int _popularCount = 6;

final productDatasourceProvider = Provider<ProductDatasource>((ref) {
  return MockProductDatasource();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.watch(productDatasourceProvider));
});

final productsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).getProducts();
});

final popularProductsProvider = FutureProvider<List<Product>>((ref) async {
  final products = await ref.watch(productsProvider.future);
  final sorted = [...products]..sort((a, b) => b.rating.compareTo(a.rating));
  return sorted.take(_popularCount).toList();
});

final productByIdProvider = FutureProvider.family<Product, String>((ref, id) async {
  final products = await ref.watch(productsProvider.future);
  return products.firstWhere((product) => product.id == id);
});
