import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../products/providers/products_providers.dart';
import '../providers/favorites_providers.dart';
import 'favorite_card.dart';

class FavoriteGrid extends ConsumerWidget {
  const FavoriteGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final products = ref.watch(productsProvider);

    return products.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Impossible de charger les produits.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      data: (items) {
        final favoriteProducts = items
            .where((product) => favorites.favoriteIds.contains(product.id))
            .toList();

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 300,
          ),
          itemCount: favoriteProducts.length,
          itemBuilder: (context, index) {
            final product = favoriteProducts[index];
            return FavoriteCard(
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
}
