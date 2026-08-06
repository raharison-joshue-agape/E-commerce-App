import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/favorites_notifier.dart';
import '../datasource/favorites_local_datasource.dart';
import '../datasource/shared_preferences_favorites_local_datasource.dart';
import '../repository/favorites_repository.dart';
import '../repository/favorites_repository_impl.dart';

final favoritesLocalDataSourceProvider =
    Provider<FavoritesLocalDataSource>((ref) {
  return SharedPreferencesFavoritesLocalDataSource();
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(ref.watch(favoritesLocalDataSourceProvider));
});

final favoritesProvider = NotifierProvider<FavoritesNotifier, FavoritesState>(
  FavoritesNotifier.new,
);
