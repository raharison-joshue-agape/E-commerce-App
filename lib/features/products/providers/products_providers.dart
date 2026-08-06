import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasource/mock_product_datasource.dart';
import '../datasource/product_datasource.dart';
import '../models/product.dart';
import '../repository/product_repository.dart';
import '../repository/product_repository_impl.dart';

const int _popularCount = 6;
const int _relatedCount = 6;

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

final productDetailProvider = FutureProvider.family<Product, String>((ref, id) {
  return ref.watch(productRepositoryProvider).getProductById(id);
}, retry: (retryCount, error) => null);

final relatedProductsProvider = FutureProvider.family<List<Product>, String>((
  ref,
  productId,
) async {
  final products = await ref.watch(productsProvider.future);
  final current = products.firstWhere((product) => product.id == productId);
  final related = products.where((product) => product.id != productId).toList()
    ..sort((a, b) {
      final sameCategoryA = a.category == current.category ? 0 : 1;
      final sameCategoryB = b.category == current.category ? 0 : 1;
      if (sameCategoryA != sameCategoryB) {
        return sameCategoryA.compareTo(sameCategoryB);
      }
      return b.rating.compareTo(a.rating);
    });
  return related.take(_relatedCount).toList();
}, retry: (retryCount, error) => null);
