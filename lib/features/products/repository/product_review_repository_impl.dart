import '../datasource/product_review_datasource.dart';
import '../models/product_review.dart';
import 'product_review_repository.dart';

class ProductReviewRepositoryImpl implements ProductReviewRepository {
  ProductReviewRepositoryImpl(this._datasource);

  final ProductReviewDatasource _datasource;

  @override
  Future<List<ProductReview>> getReviews(String productId) {
    return _datasource.getReviews(productId);
  }
}
