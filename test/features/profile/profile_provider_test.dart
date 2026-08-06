import 'package:e_commerce_app/features/profile/datasource/mock_profile_local_datasource.dart';
import 'package:e_commerce_app/features/profile/datasource/profile_local_datasource.dart';
import 'package:e_commerce_app/features/profile/models/user.dart';
import 'package:e_commerce_app/features/profile/providers/profile_providers.dart';
import 'package:e_commerce_app/features/profile/repository/profile_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('profileProvider loads the mocked user', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final user = await container.read(profileProvider.future);

    expect(user.id, 'user-1');
    expect(user.fullName, 'Camille Laurent');
    expect(user.initials, 'CL');
    expect(user.email, 'camille.laurent@example.com');
    expect(user.phone, '+33 6 12 34 56 78');
    expect(user.avatarUrl, isNotEmpty);
    expect(user.address, '12 rue des Fleurs');
    expect(user.city, 'Lyon');
    expect(user.country, 'France');
    expect(user.postalCode, '69002');
    expect(user.memberSince, DateTime(2023, 3, 15));
    expect(user.loyaltyLevel, 'Gold');
    expect(user.totalOrders, 24);
    expect(user.totalSpent, 3487.5);
  });

  test('ProfileRepositoryImpl delegates to the datasource', () async {
    final repository = ProfileRepositoryImpl(const MockProfileLocalDataSource());

    final user = await repository.getProfile();

    expect(user, isA<User>());
    expect(user.fullName, 'Camille Laurent');
  });

  test('a failing datasource produces an AsyncError', () async {
    final container = ProviderContainer(
      overrides: [
        profileLocalDataSourceProvider.overrideWithValue(
          _FailingProfileLocalDataSource(),
        ),
      ],
      retry: (retryCount, error) => null,
    );
    addTearDown(container.dispose);

    final states = <AsyncValue<User>>[];
    final subscription = container.listen(profileProvider, (previous, next) {
      states.add(next);
    });

    await Future<void>.delayed(const Duration(milliseconds: 100));
    subscription.close();

    final state = container.read(profileProvider);
    expect(state, isA<AsyncError<User>>());
    expect(state.hasError, isTrue);
    expect(state.error, isA<Exception>());
    expect(states.any((s) => s is AsyncError<User>), isTrue);
  });
}

class _FailingProfileLocalDataSource implements ProfileLocalDataSource {
  @override
  Future<User> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    throw Exception('Cannot load profile');
  }
}
