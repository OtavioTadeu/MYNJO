import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Marcus Vinicius

// Mostra uma mensagem verde na parte de baixo da tela
void mostrarMensagemSucesso(BuildContext context, String texto) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(texto)),
        ],
      ),
      backgroundColor: AppColors.income,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

// Mostra uma mensagem vermelha na parte de baixo da tela
void mostrarMensagemErro(BuildContext context, String texto) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(texto)),
        ],
      ),
      backgroundColor: AppColors.expense,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
