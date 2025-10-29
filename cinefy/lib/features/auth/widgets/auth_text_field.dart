import 'package:flutter/material.dart';


class AuthTextField extends StatelessWidget {
final TextEditingController controller;
final String label;
final TextInputType keyboardType;
final bool obscure;
final String? Function(String?)? validator;


const AuthTextField({super.key, required this.controller, required this.label, this.keyboardType = TextInputType.text, this.obscure = false, this.validator});


@override
Widget build(BuildContext context) {
return TextFormField(
controller: controller,
obscureText: obscure,
keyboardType: keyboardType,
validator: validator,
decoration: InputDecoration(labelText: label),
);
}
}