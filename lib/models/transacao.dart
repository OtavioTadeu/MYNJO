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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo.name,
      'descricao': descricao,
      'valor': valor,
      'categoria': categoria,
      'data': data.toIso8601String(),
    };
  }

  factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(
      id: json['id'] as String? ?? '',
      tipo: TipoTransacao.values.firstWhere(
        (t) => t.name == json['tipo'],
        orElse: () => TipoTransacao.saida,
      ),
      descricao: json['descricao'] as String? ?? '',
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
      categoria: json['categoria'] as String? ?? 'Outros',
      data: json['data'] != null
          ? DateTime.tryParse(json['data'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
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
    id: 'e0',
    tipo: TipoTransacao.entrada,
    descricao: 'Depósito inicial',
    valor: 100.0,
    categoria: 'Outros',
    data: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Transacao(
    id: 's0',
    tipo: TipoTransacao.saida,
    descricao: 'Lanche / Mercado',
    valor: 32.58,
    categoria: 'Alimentação',
    data: DateTime.now(),
  ),
];
