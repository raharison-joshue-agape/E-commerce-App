import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_view.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Favoris',
      icon: Icons.favorite_outline,
      message: 'Cette fonctionnalité sera développée prochainement.',
    );
  }
}
