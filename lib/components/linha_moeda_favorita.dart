import 'package:flutter/material.dart';
import '../models/moeda.dart';
import '../theme/app_colors.dart';

// Marcus Vinicius

// Linha de uma moeda com a estrelinha para favoritar.
// Usada na tela de Relatório.
class LinhaMoedaFavorita extends StatelessWidget {
  final MoedaCotacao moeda;
  final VoidCallback onFavoritar;

  const LinhaMoedaFavorita({
    super.key,
    required this.moeda,
    required this.onFavoritar,
  });

  @override
  Widget build(BuildContext context) {
    bool subiu = moeda.variacaoPercentual >= 0;

    int casasDecimais = 2;
    if (moeda.valorVenda < 1) {
      casasDecimais = 4;
    }

    String textoVariacao;
    if (subiu) {
      textoVariacao = '▲ ${moeda.variacaoPercentual.abs()}%';
    } else {
      textoVariacao = '▼ ${moeda.variacaoPercentual.abs()}%';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(moeda.bandeira, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moeda.codigo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  moeda.nome,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'R\$ ${moeda.valorVenda.toStringAsFixed(casasDecimais)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                textoVariacao,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: subiu ? AppColors.income : AppColors.expense,
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: moeda.favorita ? 'Remover dos favoritos' : 'Favoritar',
            onPressed: onFavoritar,
            icon: Icon(
              moeda.favorita ? Icons.star_rounded : Icons.star_outline_rounded,
              color: moeda.favorita ? AppColors.starGold : AppColors.textMuted,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
