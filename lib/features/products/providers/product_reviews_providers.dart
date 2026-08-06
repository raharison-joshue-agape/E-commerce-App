import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasource/mock_product_review_datasource.dart';
import '../datasource/product_review_datasource.dart';
import '../models/product_review.dart';
import '../repository/product_review_repository.dart';
import '../repository/product_review_repository_impl.dart';

final productReviewDatasourceProvider = Provider<ProductReviewDatasource>((ref) {
  return MockProductReviewDatasource();
});

final productReviewRepositoryProvider = Provider<ProductReviewRepository>((ref) {
  return ProductReviewRepositoryImpl(ref.watch(productReviewDatasourceProvider));
});

final productReviewsProvider = FutureProvider.family<List<ProductReview>, String>(
  (ref, productId) {
    return ref.watch(productReviewRepositoryProvider).getReviews(productId);
  },
  retry: (retryCount, error) => null,
);
