abstract interface class FavoritesLocalDataSource {
  Future<List<String>> readFavoriteIds();
  Future<void> writeFavoriteIds(List<String> ids);
}
