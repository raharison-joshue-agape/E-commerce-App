class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.imageUrl,
    required this.category,
    required this.brand,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.rating,
    required this.reviewCount,
    required this.stock,
    required this.isAvailable,
    required this.colors,
    required this.sizes,
    required this.images,
    required this.specifications,
  });

  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final String imageUrl;
  final String category;
  final String brand;
  final double price;
  final double? oldPrice;
  final double? discount;
  final double rating;
  final int reviewCount;
  final int stock;
  final bool isAvailable;
  final List<String> colors;
  final List<String> sizes;
  final List<String> images;
  final Map<String, String> specifications;

  bool get hasDiscount => oldPrice != null && oldPrice! > price;
}
