import '../datasource/product_datasource.dart';
import '../models/product.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._datasource);

  final ProductDatasource _datasource;

  @override
  Future<List<Product>> getProducts() => _datasource.getProducts();
}
