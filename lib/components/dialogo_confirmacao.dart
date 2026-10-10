import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Marcus Vinicius

// Abre uma caixinha perguntando se o usuário tem certeza.
// Se ele clicar no botão vermelho, a função "aoConfirmar" é chamada.
void mostrarDialogoConfirmacao({
  required BuildContext context,
  required String titulo,
  required String mensagem,
  required String textoBotao,
  required VoidCallback aoConfirmar,
}) {
  showDialog(
    context: context,
    builder: (contextoDialogo) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(contextoDialogo);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.expense,
              minimumSize: const Size(100, 42),
            ),
            onPressed: () {
              Navigator.pop(contextoDialogo);
              aoConfirmar();
            },
            child: Text(textoBotao),
          ),
        ],
      );
    },
  );
}
