import 'package:flutter/material.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key, required this.onContinueShopping});

  final VoidCallback onContinueShopping;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 56,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Votre panier est vide.',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Parcourez notre catalogue et ajoutez vos produits préférés.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onContinueShopping,
              icon: const Icon(Icons.grid_view),
              label: const Text('Continuer vos achats'),
            ),
          ],
        ),
      ),
    );
  }
}
