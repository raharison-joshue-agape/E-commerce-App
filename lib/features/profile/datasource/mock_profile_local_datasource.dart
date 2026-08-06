import '../models/user.dart';
import 'profile_local_datasource.dart';

class MockProfileLocalDataSource implements ProfileLocalDataSource {
  const MockProfileLocalDataSource();

  @override
  Future<User> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockUser;
  }
}

final User _mockUser = User(
  id: 'user-1',
  firstName: 'Camille',
  lastName: 'Laurent',
  email: 'camille.laurent@example.com',
  phone: '+33 6 12 34 56 78',
  avatarUrl: 'https://picsum.photos/seed/camille/200/200',
  address: '12 rue des Fleurs',
  city: 'Lyon',
  country: 'France',
  postalCode: '69002',
  memberSince: DateTime(2023, 3, 15),
  loyaltyLevel: 'Gold',
  totalOrders: 24,
  totalSpent: 3487.5,
);
