import 'package:flutter/material.dart';
import '../utils/formatadores.dart';

// Marcus Vinicius

// Campo de e-mail que já vem com a validação pronta
class CampoEmail extends StatelessWidget {
  final TextEditingController controller;

  const CampoEmail({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        hintText: 'voce@email.com',
        prefixIcon: Icon(Icons.alternate_email_rounded, size: 20),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Digite seu e-mail';
        }
        if (!emailValido(value.trim())) {
          return 'E-mail inválido';
        }
        return null;
      },
    );
  }
}
