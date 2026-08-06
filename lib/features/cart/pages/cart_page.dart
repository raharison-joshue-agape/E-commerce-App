import 'package:flutter/material.dart';

import '../../../core/widgets/placeholder_view.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      title: 'Panier',
      icon: Icons.shopping_cart_outlined,
      message: 'Cette fonctionnalité sera développée prochainement.',
    );
  }
}
