import 'package:flutter/material.dart';
import '../models/transacao.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import 'cartao_branco.dart';

// Marcus Vinicius

// Mostra uma transação na lista (ícone, descrição, categoria, data e valor).
// Se "onExcluir" for passado, aparece o botão de lixeira.
class ItemTransacao extends StatelessWidget {
  final Transacao transacao;
  final VoidCallback? onExcluir;

  const ItemTransacao({
    super.key,
    required this.transacao,
    this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    // escolhe as cores de acordo com o tipo
    Color corIcone;
    Color corFundoIcone;
    if (transacao.isEntrada) {
      corIcone = AppColors.income;
      corFundoIcone = AppColors.incomeLight;
    } else if (transacao.isFixo) {
      corIcone = AppColors.fixed;
      corFundoIcone = AppColors.fixedLight;
    } else {
      corIcone = AppColors.expense;
      corFundoIcone = AppColors.expenseLight;
    }

    Color corValor;
    String sinal;
    if (transacao.isEntrada) {
      corValor = AppColors.income;
      sinal = '+';
    } else {
      corValor = AppColors.expense;
      sinal = '-';
    }

    // linha de baixo: categoria, etiqueta "Fixo" (se for) e data
    List<Widget> linhaDeBaixo = [];
    linhaDeBaixo.add(
      Text(
        transacao.categoria,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
    );
    if (transacao.isFixo) {
      linhaDeBaixo.add(const SizedBox(width: 6));
      linhaDeBaixo.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
          decoration: BoxDecoration(
            color: AppColors.fixedLight,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Fixo',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.fixed,
            ),
          ),
        ),
      );
    }
    linhaDeBaixo.add(const SizedBox(width: 6));
    linhaDeBaixo.add(
      Text(
        '• ${formatarData(transacao.data)}',
        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
      ),
    );

    // itens da linha principal
    List<Widget> itens = [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: corFundoIcone,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(iconeDaCategoria(transacao.categoria), size: 20, color: corIcone),
      ),
      const SizedBox(width: 14),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transacao.descricao,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Row(children: linhaDeBaixo),
          ],
        ),
      ),
      Text(
        '$sinal ${formatarMoeda(transacao.valor)}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: corValor,
        ),
      ),
    ];

    if (onExcluir != null) {
      itens.add(const SizedBox(width: 4));
      itens.add(
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textMuted, size: 20),
          tooltip: 'Excluir',
          onPressed: onExcluir,
        ),
      );
    }

    return CartaoBranco(
      child: Row(children: itens),
    );
  }
}
