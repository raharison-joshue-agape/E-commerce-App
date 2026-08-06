import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../controllers/favorites_notifier.dart';
import '../providers/favorites_providers.dart';
import '../widgets/empty_favorites_widget.dart';
import '../widgets/favorite_grid.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favoris',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: _buildBody(context, ref, favorites),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, FavoritesState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return _FavoritesErrorView(
        onRetry: () => ref.read(favoritesProvider.notifier).initialize(),
      );
    }
    if (state.isEmpty) {
      return EmptyFavoritesWidget(
        onExplore: () => context.go(AppRoutes.products),
      );
    }
    return const FavoriteGrid();
  }
}

class _FavoritesErrorView extends StatelessWidget {
  const _FavoritesErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: colors.onErrorContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Impossible de charger vos favoris.',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Veuillez réessayer dans quelques instants.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
