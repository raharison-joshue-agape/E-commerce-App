import 'package:e_commerce_app/core/errors/product_not_found_exception.dart';
import 'package:e_commerce_app/features/products/datasource/product_datasource.dart';
import 'package:e_commerce_app/features/products/models/product.dart';
import 'package:e_commerce_app/features/products/models/product_sort_option.dart';
import 'package:e_commerce_app/features/products/providers/product_filters_providers.dart';
import 'package:e_commerce_app/features/products/providers/products_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ProviderContainer createContainer({List<Product>? products}) {
    final container = ProviderContainer(
      overrides: products == null
          ? const []
          : [
              productDatasourceProvider.overrideWithValue(
                _TestProductDatasource(products),
              ),
            ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<List<Product>> filteredProducts(ProviderContainer container) async {
    await container.read(productsProvider.future);
    return container.read(filteredProductsProvider).value ?? const <Product>[];
  }

  Future<List<String>> filteredIds(ProviderContainer container) async {
    final products = await filteredProducts(container);
    return products.map((product) => product.id).toList();
  }

  group('filteredProductsProvider', () {
    test('returns all products by default', () async {
      final container = createContainer();

      final ids = await filteredIds(container);

      expect(ids.length, 12);
      expect(ids.first, 'iphone-15-pro');
    });

    test('searches by name, case-insensitive', () async {
      final container = createContainer();
      container
          .read(productFiltersProvider.notifier)
          .setSearchQuery('IPHONE');

      final ids = await filteredIds(container);

      expect(ids, ['iphone-15-pro']);
    });

    test('searches by brand', () async {
      final container = createContainer();
      container.read(productFiltersProvider.notifier).setSearchQuery('apple');

      final ids = await filteredIds(container);

      expect(ids.toSet(), {'iphone-15-pro', 'macbook-air-m3', 'airpods-pro-2'});
    });

    test('searches by category', () async {
      final container = createContainer();
      container.read(productFiltersProvider.notifier).setSearchQuery('audio');

      final ids = await filteredIds(container);

      expect(ids.toSet(), {'airpods-pro-2', 'sony-wh1000xm5'});
    });

    test('filters by category', () async {
      final container = createContainer();
      container.read(productFiltersProvider.notifier).setCategory('Gaming');

      final ids = await filteredIds(container);

      expect(ids.toSet(), {'playstation-5', 'xbox-series-x'});
    });

    test('filters by price range', () async {
      final container = createContainer();
      container
          .read(productFiltersProvider.notifier)
          .setPriceRange(const RangeValues(0, 500));

      final products = await filteredProducts(container);

      expect(products, isNotEmpty);
      expect(products.every((product) => product.price <= 500), isTrue);
      expect(
        products.map((product) => product.id),
        containsAll({'airpods-pro-2', 'xbox-series-x', 'leather-backpack'}),
      );
    });

    test('filters by availability', () async {
      final container = createContainer(
        products: const [
          _Product(id: 'dispo', name: 'Produit dispo', isAvailable: true),
          _Product(id: 'rupture', name: 'Produit rupture', isAvailable: false),
        ],
      );
      container.read(productFiltersProvider.notifier).setOnlyAvailable(true);

      final ids = await filteredIds(container);

      expect(ids, ['dispo']);
    });

    test('sorts by price ascending', () async {
      final container = createContainer();
      container
          .read(productFiltersProvider.notifier)
          .setSort(ProductSortOption.priceAscending);

      final products = await filteredProducts(container);

      expect(products.first.id, 'leather-backpack');
      expect(products.last.id, 'iphone-15-pro');
    });

    test('sorts by price descending', () async {
      final container = createContainer();
      container
          .read(productFiltersProvider.notifier)
          .setSort(ProductSortOption.priceDescending);

      final products = await filteredProducts(container);

      expect(products.first.id, 'iphone-15-pro');
      expect(products.last.id, 'leather-backpack');
    });

    test('sorts by name ascending', () async {
      final container = createContainer();
      container
          .read(productFiltersProvider.notifier)
          .setSort(ProductSortOption.nameAscending);

      final products = await filteredProducts(container);

      expect(products.first.name, 'AirPods Pro 2');
    });

    test('sorts by name descending', () async {
      final container = createContainer();
      container
          .read(productFiltersProvider.notifier)
          .setSort(ProductSortOption.nameDescending);

      final products = await filteredProducts(container);

      expect(products.first.name, 'Xbox Series X');
    });

    test('sorts by rating', () async {
      final container = createContainer();
      container
          .read(productFiltersProvider.notifier)
          .setSort(ProductSortOption.bestRated);

      final products = await filteredProducts(container);

      expect(products.first.id, 'macbook-air-m3');
    });

    test('sorts by discount', () async {
      final container = createContainer();
      container
          .read(productFiltersProvider.notifier)
          .setSort(ProductSortOption.bestDiscount);

      final products = await filteredProducts(container);

      expect(products.first.id, 'leather-backpack');
    });

    test('combines search, category, price and sort', () async {
      final container = createContainer();
      final notifier = container.read(productFiltersProvider.notifier);
      notifier.setSearchQuery('sony');
      notifier.setCategory('Audio');
      notifier.setPriceRange(const RangeValues(0, 400));
      notifier.setSort(ProductSortOption.priceAscending);

      final products = await filteredProducts(container);

      expect(products, hasLength(1));
      expect(products.single.id, 'sony-wh1000xm5');
    });

    test('returns an empty list when nothing matches', () async {
      final container = createContainer();
      container.read(productFiltersProvider.notifier).setSearchQuery('zzzzz');

      final products = await filteredProducts(container);

      expect(products, isEmpty);
    });

    test('resetFilters restores the defaults', () async {
      final container = createContainer();
      final notifier = container.read(productFiltersProvider.notifier);
      notifier.setSearchQuery('iphone');
      notifier.setCategory('Audio');
      notifier.setPriceRange(const RangeValues(0, 200));
      notifier.setOnlyAvailable(true);
      notifier.setSort(ProductSortOption.bestRated);

      notifier.resetFilters();

      final state = container.read(productFiltersProvider);
      expect(state.searchQuery, '');
      expect(state.selectedCategory, isNull);
      expect(state.priceRange, container.read(priceBoundsProvider));
      expect(state.onlyAvailable, isFalse);
      expect(state.sort, ProductSortOption.relevance);

      final ids = await filteredIds(container);
      expect(ids.length, 12);
    });
  });

  group('derived providers', () {
    test('categoriesProvider returns unique sorted categories', () async {
      final container = createContainer();
      await container.read(productsProvider.future);

      expect(container.read(categoriesProvider), [
        'Accessories',
        'Audio',
        'Fashion',
        'Gaming',
        'Laptops',
        'Smartphones',
      ]);
    });

    test('priceBoundsProvider reflects product prices', () async {
      final container = createContainer();
      await container.read(productsProvider.future);

      expect(container.read(priceBoundsProvider), const RangeValues(69, 1299));
    });

    test('activeFilterCountProvider counts active filters', () async {
      final container = createContainer();
      final notifier = container.read(productFiltersProvider.notifier);

      expect(container.read(activeFilterCountProvider), 0);

      notifier.setSearchQuery('iphone');
      expect(container.read(activeFilterCountProvider), 1);

      notifier.setCategory('Audio');
      expect(container.read(activeFilterCountProvider), 2);

      notifier.resetFilters();
      expect(container.read(activeFilterCountProvider), 0);
    });
  });
}

class _TestProductDatasource implements ProductDatasource {
  _TestProductDatasource(this.products);

  final List<Product> products;

  @override
  Future<List<Product>> getProducts() async => products;

  @override
  Future<Product> getProductById(String id) async {
    return products.firstWhere(
      (product) => product.id == id,
      orElse: () => throw ProductNotFoundException(id),
    );
  }
}

class _Product extends Product {
  const _Product({
    required super.id,
    required super.name,
    super.price = 100,
    super.discount,
    super.rating = 4.0,
    super.isAvailable = true,
    super.brand = 'Marque',
    super.category = 'Test',
  }) : super(
         description: '',
         shortDescription: '',
         imageUrl: '',
         oldPrice: null,
         reviewCount: 1,
         stock: 10,
         colors: const [],
         sizes: const [],
         images: const [],
         specifications: const {},
       );
}
