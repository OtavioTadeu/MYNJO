import 'package:flutter/material.dart';

// Marcus Vinicius

// Funções de ajuda usadas em várias telas.

// Transforma 1500.5 em "R$ 1.500,50"
String formatarMoeda(double valor) {
  // separa a parte inteira da parte decimal
  List<String> partes = valor.abs().toStringAsFixed(2).split('.');
  String parteInteira = partes[0];
  String parteDecimal = partes[1];

  // coloca um ponto a cada 3 números (de trás pra frente)
  String inteiraComPontos = '';
  int contador = 0;
  for (int i = parteInteira.length - 1; i >= 0; i--) {
    inteiraComPontos = '${parteInteira[i]}$inteiraComPontos';
    contador++;
    if (contador == 3 && i > 0) {
      inteiraComPontos = '.$inteiraComPontos';
      contador = 0;
    }
  }

  if (valor < 0) {
    return '- R\$ $inteiraComPontos,$parteDecimal';
  }
  return 'R\$ $inteiraComPontos,$parteDecimal';
}

// Transforma uma data em "05 out"
String formatarData(DateTime data) {
  List<String> meses = [
    'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
    'jul', 'ago', 'set', 'out', 'nov', 'dez',
  ];
  String dia = data.day.toString().padLeft(2, '0');
  String mes = meses[data.month - 1];
  return '$dia $mes';
}

// Transforma uma data em "05/10/2026"
String formatarDataCompleta(DateTime data) {
  String dia = data.day.toString().padLeft(2, '0');
  String mes = data.month.toString().padLeft(2, '0');
  String ano = data.year.toString();
  return '$dia/$mes/$ano';
}

// Retorna o ícone de acordo com o nome da categoria
IconData iconeDaCategoria(String categoria) {
  String nome = categoria.toLowerCase();

  switch (nome) {
    case 'salário':
      return Icons.attach_money_rounded;
    case 'freelance':
      return Icons.work_outline_rounded;
    case 'moradia':
      return Icons.home_rounded;
    case 'alimentação':
      return Icons.restaurant_rounded;
    case 'transporte':
      return Icons.directions_car_rounded;
    case 'lazer':
      return Icons.movie_creation_outlined;
    case 'saúde':
      return Icons.favorite_border_rounded;
    case 'educação':
      return Icons.school_outlined;
    case 'assinaturas':
      return Icons.subscriptions_outlined;
    default:
      return Icons.account_balance_wallet_outlined;
  }
}

// Verifica se o e-mail tem um formato válido
bool emailValido(String email) {
  RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}
