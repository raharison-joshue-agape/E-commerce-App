import '../models/product.dart';

abstract interface class ProductDatasource {
  Future<List<Product>> getProducts();
}
