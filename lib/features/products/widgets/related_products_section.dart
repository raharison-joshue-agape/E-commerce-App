import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../models/product.dart';
import '../providers/products_providers.dart';
import 'product_card.dart';
import 'section_title.dart';

class RelatedProductsSection extends ConsumerWidget {
  const RelatedProductsSection({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final related = ref.watch(relatedProductsProvider(product.id));

    return related.when(
      loading: () => const SizedBox(
        height: 280,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SectionTitle(title: 'Produits similaires'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return SizedBox(
                    width: 170,
                    child: ProductCard(
                      product: item,
                      onTap: () => context.push(
                        AppRoutes.productDetailFor(item.id),
                        extra: item,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
