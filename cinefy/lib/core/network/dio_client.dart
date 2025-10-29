import 'package:dio/dio.dart';
import '../storage/prefs.dart';


class DioClient {
static final Dio _dio = Dio(
BaseOptions(
baseUrl: 'https://54fvlk9z-4000.inc1.devtunnels.ms/api', // provided
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
}
return handler.next(options);
},
onError: (e, handler) {
// optional: unify errors here
return handler.next(e);
},
));
return _dio;
}
}