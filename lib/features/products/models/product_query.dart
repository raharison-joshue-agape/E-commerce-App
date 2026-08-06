import 'product.dart';
import 'product_sort_option.dart';

class ProductQuery {
  const ProductQuery({
    this.search = '',
    this.category,
    this.minPrice = 0,
    this.maxPrice = double.infinity,
    this.onlyAvailable = false,
    this.sort = ProductSortOption.relevance,
  });

  final String search;
  final String? category;
  final double minPrice;
  final double maxPrice;
  final bool onlyAvailable;
  final ProductSortOption sort;

  List<Product> apply(List<Product> products) {
    final term = search.trim().toLowerCase();
    final matches = products.where((product) {
      final matchesSearch =
          term.isEmpty ||
          product.name.toLowerCase().contains(term) ||
          product.brand.toLowerCase().contains(term) ||
          product.category.toLowerCase().contains(term);
      final matchesCategory = category == null || product.category == category;
      final matchesPrice =
          product.price >= minPrice && product.price <= maxPrice;
      final matchesAvailability = !onlyAvailable || product.isAvailable;
      return matchesSearch &&
          matchesCategory &&
          matchesPrice &&
          matchesAvailability;
    }).toList();

    _sort(matches);
    return matches;
  }

  void _sort(List<Product> products) {
    switch (sort) {
      case ProductSortOption.relevance:
        return;
      case ProductSortOption.priceAscending:
        products.sort((a, b) => a.price.compareTo(b.price));
      case ProductSortOption.priceDescending:
        products.sort((a, b) => b.price.compareTo(a.price));
      case ProductSortOption.nameAscending:
        products.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      case ProductSortOption.nameDescending:
        products.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
      case ProductSortOption.bestRated:
        products.sort((a, b) => b.rating.compareTo(a.rating));
      case ProductSortOption.bestDiscount:
        products.sort((a, b) => _discountOf(b).compareTo(_discountOf(a)));
    }
  }

  static double _discountOf(Product product) => product.discount ?? 0;
}
