import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/prefs.dart';
import '../../../core/utils/jwt.dart';
import '../models/auth_response.dart';
import '../models/user_dto.dart';


class AuthService {
final Dio _dio = DioClient.instance;


Future<AuthResponse> login({required String email, required String password}) async {
final res = await _dio.post('/auth/login', data: {
'email': email.trim(),
'password': password,
});
final data = AuthResponse.fromJson(res.data as Map<String, dynamic>);
await Prefs.saveToken(data.token);
return data;
}


Future<AuthResponse> register({required String name, required String email, required String password}) async {
final res = await _dio.post('/auth/register', data: {
'name': name.trim(),
'email': email.trim(),
'password': password,
});
final data = AuthResponse.fromJson(res.data as Map<String, dynamic>);
await Prefs.saveToken(data.token);
return data;
}


Future<UserDto?> currentUser() async {
final token = await Prefs.token;
if (token == null) return null;
final payload = JwtUtils.tryDecode(token);
if (payload == null) return null;
return UserDto.fromJwt(payload);
}


Future<void> logout() async => Prefs.clear();
}