import 'package:e_commerce_app/features/favorites/datasource/shared_preferences_favorites_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('reads an empty list when nothing is stored', () async {
    final datasource = SharedPreferencesFavoritesLocalDataSource();

    final ids = await datasource.readFavoriteIds();

    expect(ids, isEmpty);
  });

  test('persists ids and reads them back', () async {
    final datasource = SharedPreferencesFavoritesLocalDataSource();

    await datasource.writeFavoriteIds(['a', 'b', 'c']);

    expect(await datasource.readFavoriteIds(), ['a', 'b', 'c']);
  });

  test('overwrites the previous list', () async {
    final datasource = SharedPreferencesFavoritesLocalDataSource();

    await datasource.writeFavoriteIds(['a', 'b']);
    await datasource.writeFavoriteIds(['c']);

    expect(await datasource.readFavoriteIds(), ['c']);
  });

  test('loads ids pre-seeded in shared preferences', () async {
    SharedPreferences.setMockInitialValues({
      'favorite_products': ['iphone-15-pro', 'airpods-pro-2'],
    });

    final datasource = SharedPreferencesFavoritesLocalDataSource();

    expect(await datasource.readFavoriteIds(), [
      'iphone-15-pro',
      'airpods-pro-2',
    ]);
  });

  test('writes empty list to clear favorites', () async {
    final datasource = SharedPreferencesFavoritesLocalDataSource();

    await datasource.writeFavoriteIds(['a']);
    await datasource.writeFavoriteIds([]);

    expect(await datasource.readFavoriteIds(), isEmpty);
  });
}
