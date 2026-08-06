class ProductReview {
  const ProductReview({
    required this.id,
    required this.author,
    required this.rating,
    required this.comment,
    required this.date,
  });

  final String id;
  final String author;
  final double rating;
  final String comment;
  final DateTime date;
}
