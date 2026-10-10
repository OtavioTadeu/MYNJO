import 'package:flutter/material.dart';

// Marcus Vinicius

// Campo de senha com o botão de "olhinho" para mostrar/esconder.
// Ele mesmo guarda se a senha está escondida ou não.
class CampoSenha extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icone;
  final String? Function(String?)? validator;

  const CampoSenha({
    super.key,
    required this.controller,
    this.label = 'Senha',
    this.icone = Icons.lock_outline_rounded,
    this.validator,
  });

  @override
  State<CampoSenha> createState() => _CampoSenhaState();
}

class _CampoSenhaState extends State<CampoSenha> {
  bool esconderSenha = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: esconderSenha,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: '••••••',
        prefixIcon: Icon(widget.icone, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            esconderSenha ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              esconderSenha = !esconderSenha;
            });
          },
        ),
      ),
      validator: widget.validator,
    );
  }
}
