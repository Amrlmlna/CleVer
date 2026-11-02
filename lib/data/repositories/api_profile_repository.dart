import '../datasources/remote_library_datasource.dart';
import '../../domain/entities/user_profile.dart';
import '../utils/data_error_mapper.dart';

/// Stage 0: the profile lives in the users/{uid} doc (merged profile fields)
/// and is now served by the backend API instead of direct Firestore writes
/// (docs/2026-10-31-encryption-architecture.md §3). The backend PUT is a
/// strict whitelist, so wallet/subscription and the FCM token can never be
/// clobbered by a profile save.
class ApiProfileRepository {
  final RemoteLibraryDataSource dataSource;

  ApiProfileRepository({RemoteLibraryDataSource? dataSource})
    : dataSource = dataSource ?? RemoteLibraryDataSource();

  Future<void> saveProfile(String uid, UserProfile profile) async {
    try {
      await dataSource.updateProfile(profile.toJson());
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }

  Future<UserProfile?> getProfile(String uid) async {
    try {
      final data = await dataSource.getProfile();
      // Empty = no profile yet (the old Firestore read returned null here).
      // A doc carrying only non-profile fields (e.g. just an FCM token) has
      // nothing to parse — the strict fromJson casts would throw, so null.
      if (data.isEmpty || !data.containsKey('fullName')) return null;
      return UserProfile.fromJson(data);
    } catch (e) {
      throw DataErrorMapper.map(e);
    }
  }
}
