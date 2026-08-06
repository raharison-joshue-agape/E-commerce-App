import '../models/product.dart';

abstract interface class ProductDatasource {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
}
