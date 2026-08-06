import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/constants/app_routes.dart';
import '../../cart/widgets/cart_badge.dart';
import '../providers/products_providers.dart';
import '../widgets/category_card.dart';
import '../widgets/home_banner.dart';
import '../widgets/product_card.dart';
import '../widgets/promotion_card.dart';
import '../widgets/section_title.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$feature bientôt disponible.')),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.storefront, color: AppTheme.accent),
            SizedBox(width: 8),
            Text(
              'NovaShop',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Recherche',
            onPressed: () => _showComingSoon(context, 'La recherche'),
          ),
          CartBadge(onPressed: () => context.go(AppRoutes.cart)),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profil',
            onPressed: () => context.go(AppRoutes.profile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: HomeBanner(
                onDiscoverTap: () => context.go(AppRoutes.products),
              ),
            ),
            const SizedBox(height: 28),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SectionTitle(title: 'Catégories'),
            ),
            const SizedBox(height: 12),
            const _CategoriesRow(),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionTitle(
                title: 'Produits populaires',
                onSeeAllTap: () => context.go(AppRoutes.products),
              ),
            ),
            const SizedBox(height: 12),
            const _PopularProductsList(),
            const SizedBox(height: 28),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SectionTitle(title: 'Offres du jour'),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PromotionCard(
                title: 'Jusqu\'à -50%',
                subtitle: 'Sur une sélection d\'accessoires et produits audio.',
                onTap: () => context.go(AppRoutes.products),
              ),
            ),
            const SizedBox(height: 32),
            const _HomeFooter(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _CategoriesRow extends StatelessWidget {
  const _CategoriesRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: kProductCategories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return CategoryCard(category: kProductCategories[index]);
        },
      ),
    );
  }
}

class _PopularProductsList extends ConsumerWidget {
  const _PopularProductsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularProducts = ref.watch(popularProductsProvider);

    return popularProducts.when(
      loading: () => const _PopularProductsPlaceholder(),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Impossible de charger les produits populaires.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      data: (products) => SizedBox(
        height: 280,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final product = products[index];
            return SizedBox(
              width: 170,
              child: ProductCard(
                product: product,
                onTap: () => context.push(
                  AppRoutes.productDetailFor(product.id),
                  extra: product,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PopularProductsPlaceholder extends StatelessWidget {
  const _PopularProductsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return const SizedBox(
            width: 170,
            child: Card(
              margin: EdgeInsets.zero,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }
}

class _HomeFooter extends StatelessWidget {
  const _HomeFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const Icon(Icons.storefront, color: AppTheme.accent, size: 28),
        const SizedBox(height: 8),
        Text(
          'Merci de visiter notre boutique.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
