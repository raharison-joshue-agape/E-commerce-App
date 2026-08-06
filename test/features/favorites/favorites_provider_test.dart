import 'package:e_commerce_app/features/favorites/controllers/favorites_notifier.dart';
import 'package:e_commerce_app/features/favorites/datasource/favorites_local_datasource.dart';
import 'package:e_commerce_app/features/favorites/providers/favorites_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<FavoritesState> load(ProviderContainer container) async {
    final notifier = container.read(favoritesProvider.notifier);
    await notifier.initialize();
    return container.read(favoritesProvider);
  }

  test('starts empty after initialization', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = await load(container);

    expect(state.isLoading, isFalse);
    expect(state.isEmpty, isTrue);
    expect(state.favoriteCount, 0);
    expect(state.favorites, isEmpty);
    expect(state.error, isNull);
  });

  test('addFavorite adds a product', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(favoritesProvider.notifier);
    await notifier.initialize();

    await notifier.addFavorite('iphone-15-pro');

    final state = container.read(favoritesProvider);
    expect(state.isFavorite('iphone-15-pro'), isTrue);
    expect(state.favoriteCount, 1);
    expect(notifier.isFavorite('iphone-15-pro'), isTrue);
  });

  test('addFavorite for an already added product is a no-op', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(favoritesProvider.notifier);
    await notifier.initialize();

    await notifier.addFavorite('iphone-15-pro');
    await notifier.addFavorite('iphone-15-pro');

    expect(container.read(favoritesProvider).favoriteCount, 1);
  });

  test('adding multiple favorites keeps all of them', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(favoritesProvider.notifier);
    await notifier.initialize();

    await notifier.addFavorite('iphone-15-pro');
    await notifier.addFavorite('airpods-pro-2');
    await notifier.addFavorite('macbook-air-m3');

    final state = container.read(favoritesProvider);
    expect(state.favoriteCount, 3);
    expect(state.favorites, {
      'iphone-15-pro',
      'airpods-pro-2',
      'macbook-air-m3',
    });
  });

  test('removeFavorite removes a product', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(favoritesProvider.notifier);
    await notifier.initialize();

    await notifier.addFavorite('iphone-15-pro');
    await notifier.removeFavorite('iphone-15-pro');

    final state = container.read(favoritesProvider);
    expect(state.isEmpty, isTrue);
    expect(state.isFavorite('iphone-15-pro'), isFalse);
  });

  test('removeFavorite for an unknown id is safe', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(favoritesProvider.notifier);
    await notifier.initialize();

    await notifier.addFavorite('iphone-15-pro');
    await notifier.removeFavorite('unknown-id');

    expect(container.read(favoritesProvider).favoriteCount, 1);
  });

  test('toggleFavorite adds then removes', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(favoritesProvider.notifier);
    await notifier.initialize();

    await notifier.toggleFavorite('iphone-15-pro');
    expect(
      container.read(favoritesProvider).isFavorite('iphone-15-pro'),
      isTrue,
    );

    await notifier.toggleFavorite('iphone-15-pro');
    expect(
      container.read(favoritesProvider).isFavorite('iphone-15-pro'),
      isFalse,
    );
  });

  test('clearFavorites removes every favorite', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(favoritesProvider.notifier);
    await notifier.initialize();

    await notifier.addFavorite('iphone-15-pro');
    await notifier.addFavorite('airpods-pro-2');
    await notifier.clearFavorites();

    final state = container.read(favoritesProvider);
    expect(state.isEmpty, isTrue);
    expect(state.favoriteCount, 0);
  });

  test('favorites persist across a restart (new provider container)', () async {
    final firstContainer = ProviderContainer();
    final firstNotifier = firstContainer.read(favoritesProvider.notifier);
    await firstNotifier.initialize();
    await firstNotifier.addFavorite('iphone-15-pro');
    await firstNotifier.addFavorite('airpods-pro-2');
    firstContainer.dispose();

    final secondContainer = ProviderContainer();
    addTearDown(secondContainer.dispose);
    final secondNotifier = secondContainer.read(favoritesProvider.notifier);
    await secondNotifier.initialize();

    final state = secondContainer.read(favoritesProvider);
    expect(state.favoriteCount, 2);
    expect(state.isFavorite('iphone-15-pro'), isTrue);
    expect(state.isFavorite('airpods-pro-2'), isTrue);
  });

  test('a read failure is reported without crashing the app', () async {
    final container = ProviderContainer(
      overrides: [
        favoritesLocalDataSourceProvider.overrideWithValue(
          _FailingFavoritesLocalDataSource(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(favoritesProvider.notifier);
    await notifier.initialize();

    final state = container.read(favoritesProvider);
    expect(state.isLoading, isFalse);
    expect(state.isEmpty, isTrue);
    expect(state.error, isNotNull);
  });

  test('a write failure rolls back the state and reports the error', () async {
    final container = ProviderContainer(
      overrides: [
        favoritesLocalDataSourceProvider.overrideWithValue(
          _WriteOnlyFailingFavoritesLocalDataSource(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final notifier = container.read(favoritesProvider.notifier);
    await notifier.initialize();

    await notifier.addFavorite('iphone-15-pro');

    final state = container.read(favoritesProvider);
    expect(state.isFavorite('iphone-15-pro'), isFalse);
    expect(state.error, isNotNull);
  });
}

class _FailingFavoritesLocalDataSource implements FavoritesLocalDataSource {
  @override
  Future<List<String>> readFavoriteIds() async {
    throw Exception('Cannot read shared preferences');
  }

  @override
  Future<void> writeFavoriteIds(List<String> ids) async {
    throw Exception('Cannot write shared preferences');
  }
}

class _WriteOnlyFailingFavoritesLocalDataSource
    implements FavoritesLocalDataSource {
  @override
  Future<List<String>> readFavoriteIds() async => const [];

  @override
  Future<void> writeFavoriteIds(List<String> ids) async {
    throw Exception('Cannot write shared preferences');
  }
}
