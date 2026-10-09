import 'package:flutter/material.dart';
import '../models/moeda.dart';
import '../models/transacao.dart';

class CotacaoHistorico {
  final DateTime data;
  final double valor;
  final double variacao;

  CotacaoHistorico({
    required this.data,
    required this.valor,
    required this.variacao,
  });
}

class TelaRelatorio extends StatefulWidget {
  const TelaRelatorio({super.key});

  @override
  State<TelaRelatorio> createState() => _TelaRelatorioState();
}

class _TelaRelatorioState extends State<TelaRelatorio> {
  String _moedaSelecionada = 'USD';
  int _diasPeriodo = 7;

  bool _carregandoCotacoes = false;
  String? _erroCotacoes;
  List<CotacaoHistorico> _historicoCotacoes = [];

  @override
  void initState() {
    super.initState();
    _buscarCotacoesPeriodo();
  }

  Future<void> _buscarCotacoesPeriodo() async {
    setState(() {
      _carregandoCotacoes = true;
      _erroCotacoes = null;
      _historicoCotacoes = [];
    });

    try {
      await Future.delayed(const Duration(milliseconds: 700));

      final moedaBase = moedasPadrao.firstWhere(
        (m) => m.codigo == _moedaSelecionada,
        orElse: () => moedasPadrao.first,
      );

      final hoje = DateTime.now();
      final List<CotacaoHistorico> lista = [];

      for (int i = 0; i < _diasPeriodo; i++) {
        final data = hoje.subtract(Duration(days: i));
        final fator = 1.0 + ((i % 5 - 2) * 0.008);
        final valor = moedaBase.valorVenda * fator;
        final variacao = ((i % 5 - 2) * 0.4);

        lista.add(
          CotacaoHistorico(
            data: data,
            valor: valor,
            variacao: variacao,
          ),
        );
      }

      setState(() {
        _historicoCotacoes = lista;
      });
    } catch (e) {
      setState(() {
        _erroCotacoes = 'Não foi possível carregar as cotações. Verifique sua conexão e tente novamente.';
      });
    } finally {
      setState(() {
        _carregandoCotacoes = false;
      });
    }
  }

  double get _totalEntradas => transacoesExemplo
      .where((t) => t.isEntrada)
      .fold(0.0, (acc, t) => acc + t.valor);

  double get _totalSaidas => transacoesExemplo
      .where((t) => !t.isEntrada)
      .fold(0.0, (acc, t) => acc + t.valor);

  double get _saldoTotal => _totalEntradas - _totalSaidas;

  double get _totalFixos => transacoesExemplo
      .where((t) => t.isFixo)
      .fold(0.0, (acc, t) => acc + t.valor);

  Map<String, double> get _gastosPorCategoria {
    final mapa = <String, double>{};
    for (final t in transacoesExemplo.where((t) => !t.isEntrada)) {
      mapa[t.categoria] = (mapa[t.categoria] ?? 0.0) + t.valor;
    }
    return mapa;
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    final categoriasGastos = _gastosPorCategoria.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final totalDespesas = _totalSaidas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório Financeiro'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Resumo Geral',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.account_balance_wallet, color: Colors.blue),
                      title: const Text('Saldo Atual'),
                      trailing: Text(
                        'R\$ ${_saldoTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _saldoTotal >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.arrow_downward, color: Colors.green),
                      title: const Text('Total de Entradas'),
                      trailing: Text(
                        '+ R\$ ${_totalEntradas.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.arrow_upward, color: Colors.red),
                      title: const Text('Total de Saídas'),
                      trailing: Text(
                        '- R\$ ${_totalSaidas.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.repeat, color: Colors.purple),
                      title: const Text('Total Gastos Fixos'),
                      trailing: Text(
                        'R\$ ${_totalFixos.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Gráfico de Gastos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${categoriasGastos.length} categoria(s)',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (categoriasGastos.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text('Nenhum gasto registrado até o momento.'),
                  ),
                ),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: categoriasGastos.map((item) {
                      final proporcao = totalDespesas > 0 ? (item.value / totalDespesas) : 0.0;
                      final percentual = (proporcao * 100).toStringAsFixed(1);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.key,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'R\$ ${item.value.toStringAsFixed(2)} ($percentual%)',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: proporcao.clamp(0.0, 1.0),
                                minHeight: 10,
                                backgroundColor: Colors.grey[200],
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Cotações por Período',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _moedaSelecionada,
                            decoration: const InputDecoration(
                              labelText: 'Moeda',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            ),
                            items: moedasPadrao.map((m) {
                              return DropdownMenuItem(
                                value: m.codigo,
                                child: Text('${m.bandeira} ${m.codigo}'),
                              );
                            }).toList(),
                            onChanged: (novo) {
                              if (novo != null) {
                                setState(() => _moedaSelecionada = novo);
                                _buscarCotacoesPeriodo();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            initialValue: _diasPeriodo,
                            decoration: const InputDecoration(
                              labelText: 'Período',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            ),
                            items: const [
                              DropdownMenuItem(value: 7, child: Text('7 dias')),
                              DropdownMenuItem(value: 15, child: Text('15 dias')),
                              DropdownMenuItem(value: 30, child: Text('30 dias')),
                            ],
                            onChanged: (novo) {
                              if (novo != null) {
                                setState(() => _diasPeriodo = novo);
                                _buscarCotacoesPeriodo();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _carregandoCotacoes ? null : _buscarCotacoesPeriodo,
                      icon: const Icon(Icons.search),
                      label: const Text('Pesquisar Cotações'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_carregandoCotacoes)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Carregando cotações do período...'),
                    ],
                  ),
                ),
              )
            else if (_erroCotacoes != null)
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 36),
                      const SizedBox(height: 8),
                      Text(
                        _erroCotacoes!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _buscarCotacoesPeriodo,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _historicoCotacoes.length,
                itemBuilder: (context, index) {
                  final item = _historicoCotacoes[index];
                  final isPositivo = item.variacao >= 0;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[50],
                        child: const Icon(Icons.calendar_today, size: 18, color: Colors.blue),
                      ),
                      title: Text(
                        _formatarData(item.data),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Cotação: R\$ ${item.valor.toStringAsFixed(4)}',
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isPositivo ? Colors.green[100] : Colors.red[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${isPositivo ? '+' : ''}${item.variacao.toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isPositivo ? Colors.green[800] : Colors.red[800],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
