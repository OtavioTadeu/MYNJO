import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Marcus Vinicius

// Um cartão branco com cantos arredondados e sombra.
// É usado em quase todas as telas.
class CartaoBranco extends StatelessWidget {
  final Widget child;
  final double arredondamento;
  final EdgeInsets padding;
  final double? largura;

  const CartaoBranco({
    super.key,
    required this.child,
    this.arredondamento = 16,
    this.padding = const EdgeInsets.all(14),
    this.largura,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(arredondamento),
        boxShadow: AppColors.cardShadow,
      ),
      child: child,
    );
  }
}
