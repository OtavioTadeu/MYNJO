import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Marcus Vinicius

// Botãozinho arredondado usado para filtrar a lista do extrato
class ChipFiltro extends StatelessWidget {
  final String texto;
  final bool selecionado;
  final Color corAtiva;
  final int quantidade;
  final VoidCallback onTap;

  const ChipFiltro({
    super.key,
    required this.texto,
    required this.selecionado,
    required this.corAtiva,
    required this.quantidade,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // cores mudam quando o chip está selecionado
    Color corFundo = AppColors.card;
    Color corBorda = AppColors.border;
    Color corTexto = AppColors.textSecondary;
    Color corFundoContador = AppColors.background;
    List<BoxShadow>? sombra;

    if (selecionado) {
      corFundo = corAtiva;
      corBorda = corAtiva;
      corTexto = Colors.white;
      corFundoContador = Colors.white.withValues(alpha: 0.25);
      sombra = [
        BoxShadow(
          color: corAtiva.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: corFundo,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: corBorda, width: 1.2),
              boxShadow: sombra,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  texto,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: corTexto,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: corFundoContador,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$quantidade',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: corTexto,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
