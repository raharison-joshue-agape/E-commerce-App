import '../datasource/profile_local_datasource.dart';
import '../models/user.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._datasource);

  final ProfileLocalDataSource _datasource;

  @override
  Future<User> getProfile() => _datasource.getProfile();
}
