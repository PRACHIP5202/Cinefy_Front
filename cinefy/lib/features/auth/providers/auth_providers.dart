import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_dto.dart';
import '../services/auth_service.dart';


final authServiceProvider = Provider<AuthService>((_) => AuthService());


final authStateProvider = StateNotifierProvider<AuthStateNotifier, AsyncValue<UserDto?>>((ref) {
return AuthStateNotifier(ref.read(authServiceProvider));
});


class AuthStateNotifier extends StateNotifier<AsyncValue<UserDto?>> {
final AuthService _service;
AuthStateNotifier(this._service) : super(const AsyncLoading()) {
refresh();
}


Future<void> refresh() async {
state = const AsyncLoading();
final user = await _service.currentUser();
state = AsyncData(user);
}


Future<String?> login(String email, String password) async {
try {
final res = await _service.login(email: email, password: password);
await refresh();
return res.message;
} catch (e) {
return e.toString();
}
}


Future<String?> register(String name, String email, String password) async {
try {
final res = await _service.register(name: name, email: email, password: password);
await refresh();
return res.message;
} catch (e) {
return e.toString();
}
}


Future<void> logout() async {
await _service.logout();
await refresh();
}
}