import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Marcus Vinicius

// Cabeçalho roxo usado nas telas de Login e Cadastro.
// Se "mostrarBotaoVoltar" for true, aparece a setinha de voltar.
// Se for false, aparece o ícone da carteira (logo).
class CabecalhoGradiente extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final bool mostrarBotaoVoltar;

  const CabecalhoGradiente({
    super.key,
    required this.titulo,
    required this.subtitulo,
    this.mostrarBotaoVoltar = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconeDoTopo;

    if (mostrarBotaoVoltar) {
      iconeDoTopo = IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        padding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      );
    } else {
      iconeDoTopo = Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.account_balance_wallet_rounded,
          color: Colors.white,
          size: 28,
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(38),
        ),
      ),
      padding: const EdgeInsets.only(left: 24, top: 56, right: 24, bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconeDoTopo,
          const SizedBox(height: 16),
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
