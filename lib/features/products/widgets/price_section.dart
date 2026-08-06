import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../core/utils/currency.dart';
import '../models/product.dart';

class PriceSection extends StatelessWidget {
  const PriceSection({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final savings = product.oldPrice != null
        ? product.oldPrice! - product.price
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              formatPrice(product.price),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (product.hasDiscount) ...[
              const SizedBox(width: 10),
              Text(
                formatPrice(product.oldPrice!),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '-${product.discount!.round()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (savings != null && savings > 0) ...[
          const SizedBox(height: 6),
          Text(
            'Économisez ${formatPrice(savings)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF2E7D32),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
