import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/services/auth_helper.dart';
import '../models/user_profile.dart';

class ProfileService {
  final Dio _dio = DioClient.instance;

  /// Get current user's profile
  /// For now returns dummy data, but ready for API integration
  Future<UserProfile> getCurrentUserProfile() async {
    // Check authentication before making API call
    final isAuth = await AuthHelper.isAuthenticated();
    if (!isAuth) {
      throw Exception('Please login to view profile');
    }

    try {
      // TODO: Replace with actual API call when backend is ready
      // final res = await _dio.get('/user/me');
      // return UserProfile.fromJson(res.data as Map<String, dynamic>);
      
      // For now, return dummy data
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      
      return const UserProfile(
        id: 'user_123',
        email: 'john.doe@example.com',
        name: 'John Doe',
        phone: '+91 98765 43210',
        profileImageUrl: 'https://i.pravatar.cc/300',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Session expired. Please login again');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Profile not found');
      }
      throw Exception('Failed to load profile: ${e.response?.data?['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  /// Update user profile
  /// For now shows success message, but ready for API integration
  Future<UserProfile> updateProfile({
    String? name,
    String? phone,
    String? profileImageUrl,
  }) async {
    // Check authentication before making API call
    final isAuth = await AuthHelper.isAuthenticated();
    if (!isAuth) {
      throw Exception('Please login to update profile');
    }

    try {
      // TODO: Replace with actual API call when backend is ready
      // final res = await _dio.put('/user/me', data: {
      //   if (name != null) 'name': name,
      //   if (phone != null) 'phone': phone,
      //   if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      // });
      // return UserProfile.fromJson(res.data as Map<String, dynamic>);
      
      // For now, simulate update and return updated dummy data
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
      
      return UserProfile(
        id: 'user_123',
        email: 'john.doe@example.com',
        name: name ?? 'John Doe',
        phone: phone ?? '+91 98765 43210',
        profileImageUrl: profileImageUrl ?? 'https://i.pravatar.cc/300',
        updatedAt: DateTime.now(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Session expired. Please login again');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Invalid profile data: ${e.response?.data?['message'] ?? 'Please check your input'}');
      }
      throw Exception('Failed to update profile: ${e.response?.data?['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Upload profile image
  /// For now shows success message, but ready for API integration
  Future<String> uploadProfileImage(String imagePath) async {
    // Check authentication before making API call
    final isAuth = await AuthHelper.isAuthenticated();
    if (!isAuth) {
      throw Exception('Please login to upload image');
    }

    try {
      // TODO: Replace with actual API call when backend is ready
      // final formData = FormData.fromMap({
      //   'image': await MultipartFile.fromFile(imagePath),
      // });
      // final res = await _dio.post('/user/upload-avatar', data: formData);
      // return res.data['imageUrl'] as String;
      
      // For now, simulate upload and return dummy URL
      await Future.delayed(const Duration(seconds: 2)); // Simulate upload delay
      
      return 'https://i.pravatar.cc/300?t=${DateTime.now().millisecondsSinceEpoch}';
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Session expired. Please login again');
      } else if (e.response?.statusCode == 413) {
        throw Exception('Image file too large. Please choose a smaller image');
      }
      throw Exception('Failed to upload image: ${e.response?.data?['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}