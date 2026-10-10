import 'package:flutter/material.dart';
import '../models/moeda.dart';
import '../theme/app_colors.dart';
import 'cartao_branco.dart';

// Marcus Vinicius

// Cartãozinho de uma moeda (bandeira, nome, valor e variação)
class CardMoeda extends StatelessWidget {
  final MoedaCotacao moeda;
  final VoidCallback onFavoritar;

  const CardMoeda({
    super.key,
    required this.moeda,
    required this.onFavoritar,
  });

  @override
  Widget build(BuildContext context) {
    bool subiu = moeda.variacaoPercentual >= 0;

    // moedas muito baratas (ex: iene) mostram 3 casas decimais
    int casasDecimais = 2;
    if (moeda.valorVenda < 1) {
      casasDecimais = 3;
    }

    String seta = subiu ? '▲' : '▼';

    return CartaoBranco(
      largura: 155,
      arredondamento: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(moeda.bandeira, style: const TextStyle(fontSize: 20)),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onFavoritar,
                  child: Icon(
                    moeda.favorita ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: moeda.favorita ? AppColors.starGold : AppColors.textMuted,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          Text(
            '${moeda.codigo} · ${moeda.nome}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'R\$ ${moeda.valorVenda.toStringAsFixed(casasDecimais)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: subiu ? AppColors.incomeLight : AppColors.expenseLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$seta ${moeda.variacaoPercentual.abs()}%',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: subiu ? AppColors.income : AppColors.expense,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
