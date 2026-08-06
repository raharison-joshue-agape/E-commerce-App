import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorites_providers.dart';

class FavoritesState {
  FavoritesState({
    Set<String> favoriteIds = const <String>{},
    this.isLoading = false,
    this.error,
  }) : _favoriteIds = Set.unmodifiable(favoriteIds);

  final Set<String> _favoriteIds;
  final bool isLoading;
  final Object? error;

  Set<String> get favoriteIds => _favoriteIds;

  Set<String> get favorites => _favoriteIds;

  int get favoriteCount => favoriteIds.length;

  bool get isEmpty => favoriteIds.isEmpty;

  bool isFavorite(String productId) => favoriteIds.contains(productId);

  FavoritesState copyWith({
    Set<String>? favoriteIds,
    bool? isLoading,
    Object? error,
    bool clearError = false,
  }) {
    return FavoritesState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class FavoritesNotifier extends Notifier<FavoritesState> {
  Future<void>? _initialization;

  @override
  FavoritesState build() {
    _ensureInitialized();
    return FavoritesState(isLoading: true);
  }

  Future<void> _load() async {
    try {
      final ids = await ref.read(favoritesRepositoryProvider).getFavoriteIds();
      state = state.copyWith(
        favoriteIds: ids.toSet(),
        isLoading: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error);
    }
  }

  Future<void> _ensureInitialized() => _initialization ??= _load();

  Future<void> initialize() async {
    _initialization = _load();
    await _initialization;
  }

  Future<void> addFavorite(String productId) async {
    await _ensureInitialized();
    if (isFavorite(productId)) return;
    state = state.copyWith(
      favoriteIds: {...state.favoriteIds, productId},
      clearError: true,
    );
    try {
      await ref.read(favoritesRepositoryProvider).addFavorite(productId);
    } catch (error) {
      state = state.copyWith(
        favoriteIds: state.favoriteIds.where((id) => id != productId).toSet(),
        error: error,
      );
    }
  }

  Future<void> removeFavorite(String productId) async {
    await _ensureInitialized();
    if (!isFavorite(productId)) return;
    state = state.copyWith(
      favoriteIds: state.favoriteIds.where((id) => id != productId).toSet(),
      clearError: true,
    );
    try {
      await ref.read(favoritesRepositoryProvider).removeFavorite(productId);
    } catch (error) {
      state = state.copyWith(
        favoriteIds: {...state.favoriteIds, productId},
        error: error,
      );
    }
  }

  Future<void> toggleFavorite(String productId) async {
    if (isFavorite(productId)) {
      await removeFavorite(productId);
    } else {
      await addFavorite(productId);
    }
  }

  Future<void> clearFavorites() async {
    await _ensureInitialized();
    final previous = state.favoriteIds;
    state = state.copyWith(
      favoriteIds: const <String>{},
      clearError: true,
    );
    try {
      await ref.read(favoritesRepositoryProvider).clearFavorites();
    } catch (error) {
      state = state.copyWith(favoriteIds: previous, error: error);
    }
  }

  bool isFavorite(String productId) => state.isFavorite(productId);
}
