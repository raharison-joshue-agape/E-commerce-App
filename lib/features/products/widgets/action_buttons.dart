import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: () =>
                  _showMessage(context, 'Ajouté aux favoris (bientôt disponible).'),
              tooltip: 'Ajouter aux favoris',
              icon: const Icon(Icons.favorite_outline),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _showMessage(
                  context,
                  'Produit ajouté au panier (bientôt disponible).',
                ),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Ajouter au panier'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: () => _showMessage(context, 'Achat bientôt disponible.'),
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.accent,
            foregroundColor: Colors.white,
          ),
          icon: const Icon(Icons.bolt),
          label: const Text('Acheter maintenant'),
        ),
      ],
    );
  }
}
