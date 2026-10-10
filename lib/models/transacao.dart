// Marcus Vinicius

enum TipoTransacao {
  entrada,
  saida,
  fixo,
}

class Transacao {
  final String id;
  final TipoTransacao tipo;
  final String descricao;
  final double valor;
  final String categoria;
  final DateTime data;

  const Transacao({
    required this.id,
    required this.tipo,
    required this.descricao,
    required this.valor,
    required this.categoria,
    required this.data,
  });

  bool get isEntrada => tipo == TipoTransacao.entrada;
  bool get isSaida => tipo == TipoTransacao.saida;
  bool get isFixo => tipo == TipoTransacao.fixo;
}

const List<String> categoriasDisponiveis = [
  'Salário',
  'Freelance',
  'Moradia',
  'Alimentação',
  'Transporte',
  'Lazer',
  'Saúde',
  'Educação',
  'Assinaturas',
  'Outros',
];

final List<Transacao> transacoesExemplo = [
  Transacao(
    id: 's0',
    tipo: TipoTransacao.entrada,
    descricao: 'Salário mensal',
    valor: 6800.0,
    categoria: 'Salário',
    data: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Transacao(
    id: 's1',
    tipo: TipoTransacao.fixo,
    descricao: 'Aluguel',
    valor: 1850.0,
    categoria: 'Moradia',
    data: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Transacao(
    id: 's2',
    tipo: TipoTransacao.saida,
    descricao: 'Supermercado',
    valor: 412.90,
    categoria: 'Alimentação',
    data: DateTime.now().subtract(const Duration(days: 4)),
  ),
  Transacao(
    id: 's3',
    tipo: TipoTransacao.fixo,
    descricao: 'Internet fibra',
    valor: 119.90,
    categoria: 'Assinaturas',
    data: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Transacao(
    id: 's4',
    tipo: TipoTransacao.saida,
    descricao: 'Uber',
    valor: 38.50,
    categoria: 'Transporte',
    data: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Transacao(
    id: 's5',
    tipo: TipoTransacao.entrada,
    descricao: 'Projeto freelance',
    valor: 1500.0,
    categoria: 'Freelance',
    data: DateTime.now().subtract(const Duration(days: 7)),
  ),
  Transacao(
    id: 's6',
    tipo: TipoTransacao.saida,
    descricao: 'Cinema',
    valor: 64.0,
    categoria: 'Lazer',
    data: DateTime.now().subtract(const Duration(days: 8)),
  ),
  Transacao(
    id: 's7',
    tipo: TipoTransacao.saida,
    descricao: 'Farmácia',
    valor: 87.30,
    categoria: 'Saúde',
    data: DateTime.now().subtract(const Duration(days: 10)),
  ),
  Transacao(
    id: 's8',
    tipo: TipoTransacao.fixo,
    descricao: 'Streaming',
    valor: 55.90,
    categoria: 'Assinaturas',
    data: DateTime.now().subtract(const Duration(days: 12)),
  ),
  Transacao(
    id: 's9',
    tipo: TipoTransacao.saida,
    descricao: 'Restaurante',
    valor: 145.0,
    categoria: 'Alimentação',
    data: DateTime.now().subtract(const Duration(days: 13)),
  ),
];
