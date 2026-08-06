import '../models/product_review.dart';
import 'product_review_datasource.dart';

class MockProductReviewDatasource implements ProductReviewDatasource {
  @override
  Future<List<ProductReview>> getReviews(String productId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _reviewsFor(productId);
  }

  List<ProductReview> _reviewsFor(String productId) {
    final offset = productId.hashCode.abs() % _authors.length;

    return List.generate(3, (index) {
      final authorIndex = (offset + index) % _authors.length;
      return ProductReview(
        id: '$productId-review-$index',
        author: _authors[authorIndex],
        rating: _ratings[index],
        comment: _comments[(offset + index) % _comments.length],
        date: _dates[index],
      );
    });
  }
}

const List<String> _authors = [
  'Sophie Martin',
  'Julien Dubois',
  'Marie Lambert',
  'Thomas Petit',
  'Claire Bernard',
  'Antoine Moreau',
];

const List<double> _ratings = [5, 4, 5];

const List<String> _comments = [
  'Excellent produit, conforme à la description. Je recommande vivement !',
  'Très bon rapport qualité-prix, je suis pleinement satisfait de mon achat.',
  'Livraison rapide et produit de qualité. Le packaging était soigné.',
  'Superbe article, exactement ce que j\'attendais. Service client au top.',
];

final List<DateTime> _dates = [
  DateTime(2026, 6, 12),
  DateTime(2026, 5, 28),
  DateTime(2026, 5, 9),
];
