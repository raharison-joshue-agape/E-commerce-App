import '../datasource/favorites_local_datasource.dart';
import 'favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._datasource);

  final FavoritesLocalDataSource _datasource;

  @override
  Future<List<String>> getFavoriteIds() => _datasource.readFavoriteIds();

  @override
  Future<void> addFavorite(String productId) async {
    final ids = await _datasource.readFavoriteIds();
    if (ids.contains(productId)) return;
    await _datasource.writeFavoriteIds([...ids, productId]);
  }

  @override
  Future<void> removeFavorite(String productId) async {
    final ids = await _datasource.readFavoriteIds();
    await _datasource.writeFavoriteIds(
      ids.where((id) => id != productId).toList(),
    );
  }

  @override
  Future<void> clearFavorites() => _datasource.writeFavoriteIds(const []);

  @override
  Future<void> saveFavoriteIds(List<String> ids) =>
      _datasource.writeFavoriteIds(ids);
}
