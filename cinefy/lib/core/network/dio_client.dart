import 'package:dio/dio.dart';
import '../storage/prefs.dart';


class DioClient {
static final Dio _dio = Dio(
BaseOptions(
baseUrl: 'https://cinefy-back.onrender.com/api', // provided
connectTimeout: const Duration(seconds: 10),
receiveTimeout: const Duration(seconds: 20),
headers: {'Content-Type': 'application/json'},
),
);


static Dio get instance {
_dio.interceptors.clear();
_dio.interceptors.add(InterceptorsWrapper(
onRequest: (options, handler) async {
final token = await Prefs.token;
if (token != null && token.isNotEmpty) {
options.headers['Authorization'] = 'Bearer $token';
          // Add alternate header to survive proxies that strip Authorization
          options.headers['x-access-token'] = token;
}
return handler.next(options);
},
onError: (e, handler) {
// Handle 401 errors by clearing invalid tokens
if (e.response?.statusCode == 401) {
// Clear potentially invalid token
Prefs.clear();
}
return handler.next(e);
},
));
return _dio;
}
}