import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/providers.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_profile.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(dioClientProvider));
});

final myProfileProvider = FutureProvider<UserProfile>((ref) async {
  return ref.watch(userRepositoryProvider).getMyProfile();
});
