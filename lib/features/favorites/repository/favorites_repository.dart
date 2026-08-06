abstract interface class FavoritesRepository {
  Future<List<String>> getFavoriteIds();
  Future<void> addFavorite(String productId);
  Future<void> removeFavorite(String productId);
  Future<void> clearFavorites();
  Future<void> saveFavoriteIds(List<String> ids);
}
