class MoedaCotacao {
  final String codigo;
  final String nome;
  final String bandeira;
  final double valorVenda;
  final double variacaoPercentual;
  bool favorita;

  MoedaCotacao({
    required this.codigo,
    required this.nome,
    required this.bandeira,
    required this.valorVenda,
    required this.variacaoPercentual,
    this.favorita = false,
  });
}

final List<MoedaCotacao> moedasPadrao = [
  MoedaCotacao(
    codigo: 'USD',
    nome: 'Dólar americano',
    bandeira: '🇺🇸',
    valorVenda: 5.42,
    variacaoPercentual: 0.35,
    favorita: true,
  ),
  MoedaCotacao(
    codigo: 'EUR',
    nome: 'Euro',
    bandeira: '🇪🇺',
    valorVenda: 5.91,
    variacaoPercentual: -0.18,
    favorita: true,
  ),
  MoedaCotacao(
    codigo: 'GBP',
    nome: 'Libra esterlina',
    bandeira: '🇬🇧',
    valorVenda: 6.87,
    variacaoPercentual: 0.42,
    favorita: false,
  ),
  MoedaCotacao(
    codigo: 'JPY',
    nome: 'Iene japonês',
    bandeira: '🇯🇵',
    valorVenda: 0.0362,
    variacaoPercentual: -0.50,
    favorita: false,
  ),
  MoedaCotacao(
    codigo: 'ARS',
    nome: 'Peso argentino',
    bandeira: '🇦🇷',
    valorVenda: 0.0058,
    variacaoPercentual: -1.20,
    favorita: false,
  ),
  MoedaCotacao(
    codigo: 'CAD',
    nome: 'Dólar canadense',
    bandeira: '🇨🇦',
    valorVenda: 3.94,
    variacaoPercentual: 0.15,
    favorita: false,
  ),
  MoedaCotacao(
    codigo: 'CHF',
    nome: 'Franco suíço',
    bandeira: '🇨🇭',
    valorVenda: 6.33,
    variacaoPercentual: 0.22,
    favorita: false,
  ),
];
