import 'package:flutter/material.dart';

class EmptySearchWidget extends StatelessWidget {
  const EmptySearchWidget({super.key, required this.onReset});

  final VoidCallback onReset;

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
                Icons.search_off,
                size: 56,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucun produit trouvé',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Essayez de modifier vos critères de recherche.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text('Réinitialiser les filtres'),
            ),
          ],
        ),
      ),
    );
  }
}
