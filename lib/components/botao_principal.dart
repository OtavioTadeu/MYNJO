import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Marcus Vinicius

// Botão roxo grande com sombra.
// Quando "carregando" for true, mostra uma bolinha girando.
class BotaoPrincipal extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final bool carregando;

  const BotaoPrincipal({
    super.key,
    required this.texto,
    required this.onPressed,
    this.carregando = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget conteudo;
    if (carregando) {
      conteudo = const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4),
      );
    } else {
      conteudo = Text(texto);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.fabShadow,
      ),
      child: ElevatedButton(
        onPressed: carregando ? null : onPressed,
        child: conteudo,
      ),
    );
  }
}
