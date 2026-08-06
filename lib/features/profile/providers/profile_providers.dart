import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasource/mock_profile_local_datasource.dart';
import '../datasource/profile_local_datasource.dart';
import '../models/user.dart';
import '../repository/profile_repository.dart';
import '../repository/profile_repository_impl.dart';

final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  return const MockProfileLocalDataSource();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileLocalDataSourceProvider));
});

final profileProvider = FutureProvider<User>((ref) {
  return ref.watch(profileRepositoryProvider).getProfile();
});
