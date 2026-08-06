import '../models/product_review.dart';

abstract interface class ProductReviewRepository {
  Future<List<ProductReview>> getReviews(String productId);
}
