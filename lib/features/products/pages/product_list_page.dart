import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../models/product.dart';
import '../providers/product_filters_providers.dart';
import '../widgets/empty_search_widget.dart';
import '../widgets/product_card.dart';
import '../widgets/product_filter_bar.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tous les produits',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          const ProductFilterBar(),
          Expanded(
            child: filtered.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => const _ProductListErrorView(),
              data: (items) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: items.isEmpty
                    ? EmptySearchWidget(
                        key: const ValueKey('empty-search'),
                        onReset: () =>
                            ref.read(productFiltersProvider.notifier).resetFilters(),
                      )
                    : _ProductGrid(key: ValueKey(items), products: items),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _crossAxisCountFor(constraints.maxWidth),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 272,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => context.push(
                AppRoutes.productDetailFor(product.id),
                extra: product,
              ),
            );
          },
        );
      },
    );
  }

  int _crossAxisCountFor(double width) {
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    return 2;
  }
}

class _ProductListErrorView extends StatelessWidget {
  const _ProductListErrorView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Impossible de charger les produits. Veuillez réessayer.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
