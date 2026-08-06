import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/cart_providers.dart';

class CartBadge extends ConsumerWidget {
  const CartBadge({super.key, required this.onPressed, this.iconSize = 24});

  final VoidCallback onPressed;
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(
      cartProvider.select((state) => state.itemCount),
    );

    return IconButton(
      onPressed: onPressed,
      tooltip: 'Panier',
      icon: Badge.count(
        count: itemCount,
        isLabelVisible: itemCount > 0,
        child: Icon(Icons.shopping_cart_outlined, size: iconSize),
      ),
    );
  }
}
