import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../providers/products_providers.dart';
import '../widgets/product_card.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tous les produits',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: products.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Impossible de charger les produits. Veuillez réessayer.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (items) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 272,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final product = items[index];
            return ProductCard(
              product: product,
              onTap: () => context.push(
                AppRoutes.productDetailFor(product.id),
              ),
            );
          },
        ),
      ),
    );
  }
}
