import 'package:flutter/material.dart';

import '../../../shared/widgets/empty_state_widget.dart';

class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.favorite_border,
      title: 'Aucun favori',
      message: 'Ajoutez des produits à vos favoris pour les retrouver facilement.',
      actionLabel: 'Découvrir les produits',
      actionIcon: Icons.explore_outlined,
      onAction: onExplore,
    );
  }
}
