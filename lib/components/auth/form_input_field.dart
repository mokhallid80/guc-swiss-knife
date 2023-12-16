import 'package:flutter/material.dart';

class FormInputField extends StatelessWidget {
  final String name;
  final IconData icon;
  final TextEditingController controller;
  final bool? isPassword;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const FormInputField(
      {super.key,
      required this.name,
      required this.icon,
      required this.controller,
      this.isPassword,
      this.validator,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: name,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
        filled: true,
        prefixIcon: Icon(icon),
      ),
      obscureText: isPassword ?? false,
      validator: validator ?? (value) => null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }
}
