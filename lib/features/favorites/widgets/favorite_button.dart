import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/app_snackbar_service.dart';
import '../providers/favorites_providers.dart';

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({
    super.key,
    required this.productId,
    this.iconSize = 22,
    this.tonal = false,
    this.unselectedColor,
  });

  final String productId;
  final double iconSize;
  final bool tonal;
  final Color? unselectedColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(
      favoritesProvider.select((state) => state.isFavorite(productId)),
    );
    final tooltip = isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris';
    final icon = _AnimatedFavoriteIcon(
      isFavorite: isFavorite,
      iconSize: iconSize,
      unselectedColor: unselectedColor,
    );

    if (tonal) {
      return IconButton.filledTonal(
        onPressed: () => _toggle(context, ref),
        tooltip: tooltip,
        icon: icon,
      );
    }
    return IconButton(
      onPressed: () => _toggle(context, ref),
      tooltip: tooltip,
      icon: icon,
    );
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(favoritesProvider.notifier);
    await notifier.toggleFavorite(productId);
    final state = ref.read(favoritesProvider);
    final isFavorite = state.isFavorite(productId);

    if (!context.mounted) return;
    AppSnackbarService.show(
      context,
      switch ((state.error, isFavorite)) {
        (final Object? error, _) when error != null =>
          'Impossible de mettre à jour les favoris.',
        (_, true) => 'Produit ajouté aux favoris',
        _ => 'Produit retiré des favoris',
      },
      type: state.error != null
          ? AppSnackbarType.error
          : AppSnackbarType.info,
    );
  }
}

class _AnimatedFavoriteIcon extends StatelessWidget {
  const _AnimatedFavoriteIcon({
    required this.isFavorite,
    required this.iconSize,
    this.unselectedColor,
  });

  final bool isFavorite;
  final double iconSize;
  final Color? unselectedColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        key: ValueKey(isFavorite),
        size: iconSize,
        color: isFavorite ? Theme.of(context).colorScheme.error : unselectedColor,
      ),
    );
  }
}
