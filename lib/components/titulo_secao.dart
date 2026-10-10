import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Marcus Vinicius

// Título de uma seção da tela, com algo opcional do lado direito
class TituloSecao extends StatelessWidget {
  final String titulo;
  final Widget? direita;

  const TituloSecao({super.key, required this.titulo, this.direita});

  @override
  Widget build(BuildContext context) {
    List<Widget> filhos = [
      Text(
        titulo,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    ];

    if (direita != null) {
      filhos.add(direita!);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: filhos,
    );
  }
}
