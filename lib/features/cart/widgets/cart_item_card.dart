import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency.dart';
import '../models/cart_item.dart';
import '../providers/cart_providers.dart';
import 'quantity_selector.dart';

class CartItemCard extends ConsumerWidget {
  const CartItemCard({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final product = item.product;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 64,
                height: 64,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => ColoredBox(
                    color: colors.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_outlined,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => ref
                            .read(cartProvider.notifier)
                            .removeProduct(item.productId),
                        tooltip: 'Supprimer',
                        visualDensity: VisualDensity.compact,
                        iconSize: 20,
                        color: colors.onSurfaceVariant,
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                  Text(
                    product.brand,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      QuantitySelector(
                        quantity: item.quantity,
                        onDecrease: () => ref
                            .read(cartProvider.notifier)
                            .decreaseQuantity(item.productId),
                        onIncrease: () => ref
                            .read(cartProvider.notifier)
                            .increaseQuantity(item.productId),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formatPrice(item.subtotal),
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              formatPrice(product.price),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
