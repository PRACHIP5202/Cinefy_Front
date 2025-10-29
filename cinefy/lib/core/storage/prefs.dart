import 'package:shared_preferences/shared_preferences.dart';


class Prefs {
static const _kToken = 'auth_token';


static Future<void> saveToken(String token) async {
final p = await SharedPreferences.getInstance();
await p.setString(_kToken, token);
}


static Future<String?> get token async {
final p = await SharedPreferences.getInstance();
return p.getString(_kToken);
}


static Future<void> clear() async {
final p = await SharedPreferences.getInstance();
await p.remove(_kToken);
}
}