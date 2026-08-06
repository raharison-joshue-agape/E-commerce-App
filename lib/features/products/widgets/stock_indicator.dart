import 'package:flutter/material.dart';

class StockIndicator extends StatelessWidget {
  const StockIndicator({
    super.key,
    required this.isAvailable,
    required this.stock,
  });

  final bool isAvailable;
  final int stock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isLowStock = isAvailable && stock > 0 && stock < 15;
    final Color color = !isAvailable
        ? theme.colorScheme.error
        : isLowStock
        ? theme.colorScheme.tertiary
        : const Color(0xFF2E7D32);
    final String label = !isAvailable
        ? 'Rupture de stock'
        : isLowStock
        ? 'Plus que $stock en stock'
        : 'En stock';

    return Row(
      children: [
        Icon(Icons.circle, size: 10, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
