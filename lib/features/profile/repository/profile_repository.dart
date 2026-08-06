import '../models/user.dart';

abstract interface class ProfileRepository {
  Future<User> getProfile();
}
