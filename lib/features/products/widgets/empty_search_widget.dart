import 'package:flutter/material.dart';

import '../../../shared/widgets/empty_state_widget.dart';

class EmptySearchWidget extends StatelessWidget {
  const EmptySearchWidget({super.key, required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      title: 'Aucun produit trouvé',
      message: 'Essayez de modifier vos critères de recherche.',
      actionLabel: 'Réinitialiser les filtres',
      actionIcon: Icons.refresh,
      onAction: onReset,
    );
  }
}
