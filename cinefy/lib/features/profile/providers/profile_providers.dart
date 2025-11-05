import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../../auth/providers/auth_providers.dart';

final profileServiceProvider = Provider<ProfileService>((_) => ProfileService());

final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  // Watch auth state to refresh when user logs in/out
  final authState = ref.watch(authStateProvider);
  
  // Only fetch if user is authenticated
  return authState.when(
    loading: () => throw Exception('Loading user data...'),
    error: (e, _) => throw Exception('Authentication error'),
    data: (user) {
      if (user == null) {
        throw Exception('Please login to view profile');
      }
      
      // For now, create UserProfile from UserDto
      // Later this will fetch from the profile service
      return UserProfile.fromUserDto(user);
      
      // TODO: Uncomment when profile service is integrated
      // final svc = ref.read(profileServiceProvider);
      // return svc.getCurrentUserProfile();
    },
  );
});

final profileUpdateProvider = StateNotifierProvider<ProfileUpdateNotifier, AsyncValue<UserProfile?>>((ref) {
  return ProfileUpdateNotifier(ref.read(profileServiceProvider));
});

class ProfileUpdateNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final ProfileService _service;
  
  ProfileUpdateNotifier(this._service) : super(const AsyncData(null));
  
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? profileImageUrl,
  }) async {
    state = const AsyncLoading();
    
    try {
      final updatedProfile = await _service.updateProfile(
        name: name,
        phone: phone,
        profileImageUrl: profileImageUrl,
      );
      state = AsyncData(updatedProfile);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
  
  Future<void> uploadProfileImage(String imagePath) async {
    state = const AsyncLoading();
    
    try {
      final imageUrl = await _service.uploadProfileImage(imagePath);
      // After uploading image, update profile with new image URL
      await updateProfile(profileImageUrl: imageUrl);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
  
  void reset() {
    state = const AsyncData(null);
  }
}