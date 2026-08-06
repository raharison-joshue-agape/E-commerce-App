import '../models/product_review.dart';

abstract interface class ProductReviewDatasource {
  Future<List<ProductReview>> getReviews(String productId);
}
