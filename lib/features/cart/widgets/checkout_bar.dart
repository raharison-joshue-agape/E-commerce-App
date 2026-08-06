import 'package:flutter/material.dart';

import '../../../core/utils/currency.dart';

class CheckoutBar extends StatelessWidget {
  const CheckoutBar({super.key, required this.total, required this.onCheckout});

  final double total;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Material(
      color: colors.surface,
      elevation: 8,
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    formatPrice(total),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: onCheckout,
              icon: const Icon(Icons.lock_outline),
              label: const Text('Commander'),
            ),
          ],
        ),
      ),
    );
  }
}
