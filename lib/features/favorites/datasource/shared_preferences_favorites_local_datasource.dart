import 'package:shared_preferences/shared_preferences.dart';

import 'favorites_local_datasource.dart';

class SharedPreferencesFavoritesLocalDataSource
    implements FavoritesLocalDataSource {
  static const String _storageKey = 'favorite_products';

  @override
  Future<List<String>> readFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_storageKey) ?? const <String>[];
  }

  @override
  Future<void> writeFavoriteIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, ids);
  }
}
