import 'package:jwt_decoder/jwt_decoder.dart';


class JwtUtils {
static Map<String, dynamic>? tryDecode(String token) {
try { return JwtDecoder.decode(token); } catch (_) { return null; }
}
}