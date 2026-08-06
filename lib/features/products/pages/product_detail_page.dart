import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../models/product.dart';
import '../providers/products_providers.dart';
import '../widgets/action_buttons.dart';
import '../widgets/color_selector.dart';
import '../widgets/description_section.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/product_info_section.dart';
import '../widgets/price_section.dart';
import '../widgets/related_products_section.dart';
import '../widgets/review_list.dart';
import '../widgets/size_selector.dart';
import '../widgets/specifications_card.dart';
import '../widgets/stock_indicator.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({
    super.key,
    required this.productId,
    this.initialProduct,
  });

  final String productId;
  final Product? initialProduct;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productDetailProvider(productId));

    return product.when(
      loading: () => _ProductDetailLoading(
        productId: productId,
        initialProduct: initialProduct,
      ),
      error: (error, stackTrace) => const _ProductNotFoundView(),
      data: (data) => _ProductDetailContent(product: data),
    );
  }
}

class _ProductDetailContent extends StatelessWidget {
  const _ProductDetailContent({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.brand,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ProductImageGallery(product: product),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductInfoSection(product: product),
                    const SizedBox(height: 16),
                    PriceSection(product: product),
                    const SizedBox(height: 12),
                    StockIndicator(
                      isAvailable: product.isAvailable,
                      stock: product.stock,
                    ),
                    if (product.colors.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      ColorSelector(colors: product.colors),
                    ],
                    if (product.sizes.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      SizeSelector(sizes: product.sizes),
                    ],
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    DescriptionSection(description: product.description),
                    const SizedBox(height: 24),
                    SpecificationsCard(specifications: product.specifications),
                    const SizedBox(height: 32),
                    ReviewList(product: product),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              RelatedProductsSection(product: product),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: ActionButtons(product: product),
      ),
    );
  }
}

class _ProductDetailLoading extends StatelessWidget {
  const _ProductDetailLoading({
    required this.productId,
    required this.initialProduct,
  });

  final String productId;
  final Product? initialProduct;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: initialProduct == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'product-image-$productId',
                  child: Image.network(
                    initialProduct!.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.image_outlined, size: 64),
                    ),
                  ),
                ),
                const Center(child: CircularProgressIndicator()),
              ],
            ),
    );
  }
}

class _ProductNotFoundView extends StatelessWidget {
  const _ProductNotFoundView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_off,
                  size: 48,
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Produit introuvable',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Ce produit n\'existe plus ou a été retiré du catalogue.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.products),
                icon: const Icon(Icons.grid_view),
                label: const Text('Retour au catalogue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
