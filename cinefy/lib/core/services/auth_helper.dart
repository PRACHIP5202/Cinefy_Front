import '../storage/prefs.dart';
import '../utils/jwt.dart';

class AuthHelper {
  /// Get the current auth token from SharedPreferences
  static Future<String?> getAuthToken() async {
    return await Prefs.token;
  }

  /// Check if user is currently authenticated (has valid token)
  static Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    if (token == null || token.isEmpty) return false;
    
    // Check if token is valid (not expired)
    final payload = JwtUtils.tryDecode(token);
    if (payload == null) return false;
    
    // Check expiration
    final exp = payload['exp'] as int?;
    if (exp != null) {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (now >= exp) return false;
    }
    
    return true;
  }

  /// Clear authentication data
  static Future<void> clearAuth() async {
    await Prefs.clear();
  }
}