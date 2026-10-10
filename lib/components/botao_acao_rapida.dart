import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'cartao_branco.dart';

// Marcus Vinicius

// Botão quadrado com ícone e texto (Entrada, Saída, Gasto fixo)
class BotaoAcaoRapida extends StatelessWidget {
  final String texto;
  final IconData icone;
  final Color corIcone;
  final Color corFundoIcone;
  final VoidCallback onTap;

  const BotaoAcaoRapida({
    super.key,
    required this.texto,
    required this.icone,
    required this.corIcone,
    required this.corFundoIcone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: CartaoBranco(
          arredondamento: 18,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: corFundoIcone,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icone, color: corIcone, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                texto,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
