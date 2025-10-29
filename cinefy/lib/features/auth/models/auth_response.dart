class AuthResponse {
final String token;
final String message;


const AuthResponse({required this.token, required this.message});


factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
token: json['token'] as String,
message: (json['message'] ?? 'OK').toString(),
);
}