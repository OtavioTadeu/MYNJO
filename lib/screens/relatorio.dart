import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/cartao_branco.dart';
import '../components/linha_moeda_favorita.dart';
import '../components/titulo_secao.dart';
import '../dados/app_dados.dart';

import '../models/transacao.dart';
import '../theme/app_colors.dart';
import '../utils/formatadores.dart';
import '../utils/dimensoes_tela.dart';

// Marcus Vinicius
// Otavio Tadeu

class TelaRelatorio extends StatefulWidget {
  const TelaRelatorio({super.key});

  @override
  State<TelaRelatorio> createState() => _TelaRelatorioState();
}

class _TelaRelatorioState extends State<TelaRelatorio> {
  String _moedaSelecionada = 'USD';
  int _diasPeriodo = 7;
  bool _inicializado = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final dados = context.read<AppDados>();
        if (!_inicializado) {
          setState(() {
            _moedaSelecionada = dados.preferencias.moedaPadrao;
            _diasPeriodo = dados.preferencias.periodoPadrao;
            _inicializado = true;
          });
          dados.carregarHistorico(_moedaSelecionada, _diasPeriodo);
        }
      }
    });
  }

  void _buscarCotacoesPeriodo() {
    context.read<AppDados>().carregarHistorico(_moedaSelecionada, _diasPeriodo);
  }

  double _calcularTotalEntradas(List<Transacao> transacoes) {
    double total = 0;
    for (Transacao t in transacoes) {
      if (t.isEntrada) total += t.valor;
    }
    return total;
  }

  double _calcularTotalSaidas(List<Transacao> transacoes) {
    double total = 0;
    for (Transacao t in transacoes) {
      if (!t.isEntrada) total += t.valor;
    }
    return total;
  }

  double _calcularTotalFixos(List<Transacao> transacoes) {
    double total = 0;
    for (Transacao t in transacoes) {
      if (t.isFixo) total += t.valor;
    }
    return total;
  }

  Map<String, double> _calcularGastosPorCategoria(List<Transacao> transacoes) {
    Map<String, double> mapa = {};
    for (Transacao t in transacoes) {
      if (t.isEntrada) continue;
      if (mapa.containsKey(t.categoria)) {
        mapa[t.categoria] = mapa[t.categoria]! + t.valor;
      } else {
        mapa[t.categoria] = t.valor;
      }
    }
    return mapa;
  }

  @override
  Widget build(BuildContext context) {
    final dados = context.watch<AppDados>();

    final totalEntradas = _calcularTotalEntradas(dados.transacoes);
    final totalSaidas = _calcularTotalSaidas(dados.transacoes);
    final saldoTotal = totalEntradas - totalSaidas;
    final totalFixos = _calcularTotalFixos(dados.transacoes);

    List<MapEntry<String, double>> categoriasGastos =
        _calcularGastosPorCategoria(dados.transacoes).entries.toList();
    categoriasGastos.sort((a, b) => b.value.compareTo(a.value));

    final totalDespesas = totalSaidas;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Relatório Financeiro'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 32) +
              EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingHorizontal(context)),
          children: [
            // ===== Resumo Geral =====
            const TituloSecao(titulo: 'Resumo Geral'),
            const SizedBox(height: 10),
            CartaoBranco(
              arredondamento: 20,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _itemResumo(
                    icone: Icons.account_balance_wallet_rounded,
                    corIcone: AppColors.primary,
                    corFundoIcone: AppColors.primaryLight,
                    titulo: 'Saldo Atual',
                    valor: formatarMoeda(saldoTotal),
                    corValor:
                        saldoTotal >= 0 ? AppColors.income : AppColors.expense,
                  ),
                  const Divider(color: AppColors.border),
                  _itemResumo(
                    icone: Icons.south_west_rounded,
                    corIcone: AppColors.income,
                    corFundoIcone: AppColors.incomeLight,
                    titulo: 'Total de Entradas',
                    valor: '+ ${formatarMoeda(totalEntradas)}',
                    corValor: AppColors.income,
                  ),
                  const Divider(color: AppColors.border),
                  _itemResumo(
                    icone: Icons.north_east_rounded,
                    corIcone: AppColors.expense,
                    corFundoIcone: AppColors.expenseLight,
                    titulo: 'Total de Saídas',
                    valor: '- ${formatarMoeda(totalSaidas)}',
                    corValor: AppColors.expense,
                  ),
                  const Divider(color: AppColors.border),
                  _itemResumo(
                    icone: Icons.repeat_rounded,
                    corIcone: AppColors.fixed,
                    corFundoIcone: AppColors.fixedLight,
                    titulo: 'Gastos Fixos',
                    valor: formatarMoeda(totalFixos),
                    corValor: AppColors.fixed,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ===== Gráfico de Gastos por Categoria =====
            TituloSecao(
              titulo: 'Gastos por Categoria',
              direita: Text(
                '${categoriasGastos.length} categoria(s)',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (categoriasGastos.isEmpty)
              const CartaoBranco(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'Nenhum gasto registrado até o momento.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              CartaoBranco(
                arredondamento: 20,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: categoriasGastos.map((item) {
                    final proporcao =
                        totalDespesas > 0 ? (item.value / totalDespesas) : 0.0;
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
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${formatarMoeda(item.value)} ($percentual%)',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.expense,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: proporcao.clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor: AppColors.expenseLight,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.expense,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 24),

            // ===== Favoritar Moedas =====
            const TituloSecao(
              titulo: 'Moedas e Favoritas',
            ),
            const SizedBox(height: 10),
            CartaoBranco(
              arredondamento: 20,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Column(
                children: [
                  for (int i = 0; i < dados.moedas.length; i++) ...[
                    LinhaMoedaFavorita(
                      moeda: dados.moedas[i],
                      onFavoritar: () {
                        dados.alternarFavorito(dados.moedas[i].codigo);
                      },
                    ),
                    if (i < dados.moedas.length - 1)
                      const Divider(color: AppColors.border, height: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ===== Cotações por Período =====
            const TituloSecao(titulo: 'Histórico de Cotação (API REST)'),
            const SizedBox(height: 10),
            CartaoBranco(
              arredondamento: 20,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _moedaSelecionada,
                          decoration: const InputDecoration(
                            labelText: 'Moeda',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                          items: dados.moedas.map((m) {
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
                          value: _diasPeriodo,
                          decoration: const InputDecoration(
                            labelText: 'Período',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
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
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: dados.carregandoHistorico
                        ? null
                        : _buscarCotacoesPeriodo,
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: const Text('Atualizar Histórico'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ===== Lista de Cotações Históricas (Loading / Erro / ListView.builder) =====
            if (dados.carregandoHistorico)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text(
                        'Carregando cotações da API REST...',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              )
            else if (dados.erroHistorico != null)
              CartaoBranco(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.expense, size: 36),
                    const SizedBox(height: 8),
                    Text(
                      dados.erroHistorico!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.expense),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _buscarCotacoesPeriodo,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dados.historicoCotacoes.length,
                itemBuilder: (context, index) {
                  final item = dados.historicoCotacoes[index];
                  final isPositivo = item.variacao >= 0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CartaoBranco(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.calendar_today_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatarDataCompleta(item.data),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Cotação: R\$ ${item.valor.toStringAsFixed(4)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPositivo
                                  ? AppColors.incomeLight
                                  : AppColors.expenseLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${isPositivo ? '+' : ''}${item.variacao.toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isPositivo
                                    ? AppColors.income
                                    : AppColors.expense,
                              ),
                            ),
                          ),
                        ],
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

  // Linha do Resumo Geral (Saldo, Entradas, Saídas, Fixos)
  Widget _itemResumo({
    required IconData icone,
    required Color corIcone,
    required Color corFundoIcone,
    required String titulo,
    required String valor,
    required Color corValor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: corFundoIcone,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icone, color: corIcone, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: corValor,
            ),
          ),
        ],
      ),
    );
  }
}
