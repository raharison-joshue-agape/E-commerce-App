import 'package:flutter/material.dart';

import '../../../shared/widgets/empty_state_widget.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key, required this.onContinueShopping});

  final VoidCallback onContinueShopping;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.shopping_cart_outlined,
      title: 'Votre panier est vide.',
      message: 'Parcourez notre catalogue et ajoutez vos produits préférés.',
      actionLabel: 'Continuer vos achats',
      actionIcon: Icons.grid_view,
      onAction: onContinueShopping,
    );
  }
}
