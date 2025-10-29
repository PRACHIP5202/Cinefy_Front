class UserDto {
final String id;
final String email;
final String? name;
final String? phone;


const UserDto({required this.id, required this.email, this.name, this.phone});


factory UserDto.fromJwt(Map<String, dynamic> payload) {
// Map JWT claims from your backend (adjust keys if different)
return UserDto(
id: payload['id']?.toString() ?? payload['sub']?.toString() ?? '',
email: payload['email']?.toString() ?? '',
name: payload['name']?.toString(),
phone: payload['phone']?.toString(),
);
}
}