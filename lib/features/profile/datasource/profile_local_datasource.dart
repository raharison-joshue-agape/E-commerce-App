import '../models/user.dart';

abstract interface class ProfileLocalDataSource {
  Future<User> getProfile();
}
