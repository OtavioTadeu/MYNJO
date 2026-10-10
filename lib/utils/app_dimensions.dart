import 'package:flutter/material.dart';

class AppDimensions {
  static double paddingHorizontal(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;

    if (larguraTela > 425) {
      return (larguraTela * .1); // padding de 10% caso a tela tenhas mais de 425 pixels lógicos de largura
    }
    return 8;
  }
}
