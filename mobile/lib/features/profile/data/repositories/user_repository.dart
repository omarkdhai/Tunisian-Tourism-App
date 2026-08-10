import 'package:dio/dio.dart';
import '../models/user_profile.dart';

class UserRepository {
  final Dio _dio;
  UserRepository(this._dio);

  Future<UserProfile> getMyProfile() async {
    try {
      final response = await _dio.get('/users/me');
      return UserProfile.fromJson(response.data);
    } catch (_) {
      // Return mock for demo
      return UserProfile(
        id: 'demo-user',
        firstName: 'Ahmed',
        lastName: 'Ben Ali',
        email: 'ahmed@example.com',
        avatarUrl: 'https://i.pravatar.cc/150?img=47',
        preferredLanguage: 'FR',
        preferredCurrency: 'TND',
        travelerType: 'COUPLE',
        numberOfTravelers: 2,
        preferredCategories: ['BEACH', 'MONUMENT', 'FOOD'],
      );
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _dio.put('/users/me', data: profile.toJson());
  }

  Future<void> updatePreferences(Map<String, dynamic> prefs) async {
    await _dio.put('/users/me/preferences', data: prefs);
  }
}
