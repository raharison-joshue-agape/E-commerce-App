import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../shared/widgets/app_skeletons.dart';
import '../../../shared/widgets/error_state_widget.dart';
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
      return const _FavoritesGridSkeleton();
    }
    if (state.error != null) {
      return ErrorStateWidget(
        title: 'Impossible de charger vos favoris.',
        message: 'Veuillez réessayer dans quelques instants.',
        onAction: () => ref.read(favoritesProvider.notifier).initialize(),
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

class _FavoritesGridSkeleton extends StatelessWidget {
  const _FavoritesGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = switch (constraints.maxWidth) {
          >= 900 => 3,
          >= 600 => 2,
          _ => 1,
        };
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 300,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => const ProductCardSkeleton(),
        );
      },
    );
  }
}
