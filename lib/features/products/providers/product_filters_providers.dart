import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../models/product_query.dart';
import '../models/product_sort_option.dart';
import 'products_providers.dart';

const RangeValues _defaultPriceRange = RangeValues(0, 3000);

final priceBoundsProvider = Provider<RangeValues>((ref) {
  final products = ref.watch(productsProvider).value ?? const <Product>[];
  if (products.isEmpty) return _defaultPriceRange;

  var minPrice = products.first.price;
  var maxPrice = products.first.price;
  for (final product in products) {
    if (product.price < minPrice) minPrice = product.price;
    if (product.price > maxPrice) maxPrice = product.price;
  }
  return RangeValues(minPrice, maxPrice);
});

final categoriesProvider = Provider<List<String>>((ref) {
  final products = ref.watch(productsProvider).value ?? const <Product>[];
  return products.map((product) => product.category).toSet().toList()..sort();
});

class ProductFiltersState {
  const ProductFiltersState({
    this.searchQuery = '',
    this.selectedCategory,
    this.priceRange = _defaultPriceRange,
    this.onlyAvailable = false,
    this.sort = ProductSortOption.relevance,
  });

  final String searchQuery;
  final String? selectedCategory;
  final RangeValues priceRange;
  final bool onlyAvailable;
  final ProductSortOption sort;

  static const Object _unset = Object();

  ProductFiltersState copyWith({
    String? searchQuery,
    Object? selectedCategory = _unset,
    RangeValues? priceRange,
    bool? onlyAvailable,
    ProductSortOption? sort,
  }) {
    return ProductFiltersState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: identical(selectedCategory, _unset)
          ? this.selectedCategory
          : selectedCategory as String?,
      priceRange: priceRange ?? this.priceRange,
      onlyAvailable: onlyAvailable ?? this.onlyAvailable,
      sort: sort ?? this.sort,
    );
  }
}

class ProductFiltersNotifier extends Notifier<ProductFiltersState> {
  @override
  ProductFiltersState build() => const ProductFiltersState();

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
  }

  void setCategory(String? value) {
    state = state.copyWith(selectedCategory: value);
  }

  void setPriceRange(RangeValues value) {
    state = state.copyWith(priceRange: value);
  }

  void setOnlyAvailable(bool value) {
    state = state.copyWith(onlyAvailable: value);
  }

  void setSort(ProductSortOption value) {
    state = state.copyWith(sort: value);
  }

  void resetFilters() {
    state = ProductFiltersState(priceRange: ref.read(priceBoundsProvider));
  }
}

final productFiltersProvider =
    NotifierProvider<ProductFiltersNotifier, ProductFiltersState>(
      ProductFiltersNotifier.new,
    );

final searchQueryProvider = Provider<String>((ref) {
  return ref.watch(productFiltersProvider.select((state) => state.searchQuery));
});

final selectedCategoryProvider = Provider<String?>((ref) {
  return ref.watch(
    productFiltersProvider.select((state) => state.selectedCategory),
  );
});

final priceRangeProvider = Provider<RangeValues>((ref) {
  return ref.watch(productFiltersProvider.select((state) => state.priceRange));
});

final availabilityProvider = Provider<bool>((ref) {
  return ref.watch(productFiltersProvider.select((state) => state.onlyAvailable));
});

final sortProvider = Provider<ProductSortOption>((ref) {
  return ref.watch(productFiltersProvider.select((state) => state.sort));
});

final activeFilterCountProvider = Provider<int>((ref) {
  final state = ref.watch(productFiltersProvider);
  final bounds = ref.watch(priceBoundsProvider);

  var count = 0;
  if (state.searchQuery.trim().isNotEmpty) count++;
  if (state.selectedCategory != null) count++;
  if (state.priceRange != bounds) count++;
  if (state.onlyAvailable) count++;
  if (state.sort != ProductSortOption.relevance) count++;
  return count;
});

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final search = ref.watch(searchQueryProvider);
  final category = ref.watch(selectedCategoryProvider);
  final priceRange = ref.watch(priceRangeProvider);
  final onlyAvailable = ref.watch(availabilityProvider);
  final sort = ref.watch(sortProvider);

  final products = ref.watch(productsProvider);
  return products.whenData(
    (items) => ProductQuery(
      search: search,
      category: category,
      minPrice: priceRange.start,
      maxPrice: priceRange.end,
      onlyAvailable: onlyAvailable,
      sort: sort,
    ).apply(items),
  );
});
