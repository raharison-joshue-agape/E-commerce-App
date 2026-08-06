import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorites_providers.dart';

class FavoriteBadge extends ConsumerWidget {
  const FavoriteBadge({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(
      favoritesProvider.select((state) => state.favoriteCount),
    );

    return Badge.count(
      count: count,
      isLabelVisible: count > 0,
      child: Icon(selected ? Icons.favorite : Icons.favorite_outline),
    );
  }
}
