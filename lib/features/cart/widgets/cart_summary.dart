import 'package:flutter/material.dart';

import '../../../core/utils/currency.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.itemCount,
    required this.subtotal,
    required this.total,
  });

  final int itemCount;
  final double subtotal;
  final double total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SummaryRow(label: 'Nombre d\'articles', value: '$itemCount'),
            const SizedBox(height: 12),
            _SummaryRow(label: 'Sous-total', value: formatPrice(subtotal)),
            const SizedBox(height: 12),
            _SummaryRow(
              label: 'Livraison',
              value: 'Gratuite',
              valueColor: colors.primary,
            ),
            const Divider(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  formatPrice(total),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
