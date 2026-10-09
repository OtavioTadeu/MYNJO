import 'package:flutter/material.dart';
import '../models/transacao.dart';
import '../theme/app_colors.dart';
import 'lancamento.dart';

class TelaExtratoLancamento extends StatefulWidget {
  const TelaExtratoLancamento({super.key});

  @override
  State<TelaExtratoLancamento> createState() => _TelaExtratoLancamentoState();
}

class _TelaExtratoLancamentoState extends State<TelaExtratoLancamento> {
  TipoTransacao? _filtroTipo;

  List<Transacao> get _transacoesFiltradas {
    if (_filtroTipo == null) {
      return transacoesExemplo;
    }
    return transacoesExemplo.where((t) => t.tipo == _filtroTipo).toList();
  }

  void _abrirNovoLancamento() async {
    final novo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaLancamento(),
      ),
    );
    if (novo != null) {
      setState(() {});
    }
  }

  void _excluirTransacao(Transacao transacao) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Excluir Lançamento?'),
        content: Text('Deseja realmente excluir "${transacao.descricao}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.expense,
              minimumSize: const Size(100, 42),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                transacoesExemplo.removeWhere((t) => t.id == transacao.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Lançamento excluído com sucesso.'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatarData(DateTime data) {
    const meses = [
      'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
      'jul', 'ago', 'set', 'out', 'nov', 'dez'
    ];
    final dia = data.day.toString().padLeft(2, '0');
    final mes = meses[data.month - 1];
    return '$dia $mes';
  }

  String _formatarMoeda(double valor) {
    final valorAbs = valor.abs();
    final partes = valorAbs.toStringAsFixed(2).split('.');
    final inteira = partes[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    final decimal = partes[1];
    final sinal = valor < 0 ? '- ' : '';
    return '${sinal}R\$ $inteira,$decimal';
  }

  IconData _obterIconeCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
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

  Widget _buildFiltroChip({
    required String label,
    required bool selecionado,
    required VoidCallback onTap,
    required Color corAtiva,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selecionado ? corAtiva : AppColors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selecionado ? corAtiva : AppColors.border,
                width: 1.2,
              ),
              boxShadow: selecionado
                  ? [
                      BoxShadow(
                        color: corAtiva.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selecionado ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: selecionado
                        ? Colors.white.withValues(alpha: 0.25)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: selecionado ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lista = _transacoesFiltradas;
    final totalEntradas = transacoesExemplo.where((t) => t.isEntrada).length;
    final totalSaidas = transacoesExemplo.where((t) => t.isSaida).length;
    final totalFixos = transacoesExemplo.where((t) => t.isFixo).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Extrato (${lista.length})',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFiltroChip(
                      label: 'Todas',
                      selecionado: _filtroTipo == null,
                      onTap: () => setState(() => _filtroTipo = null),
                      corAtiva: AppColors.primary,
                      count: transacoesExemplo.length,
                    ),
                    _buildFiltroChip(
                      label: 'Entradas',
                      selecionado: _filtroTipo == TipoTransacao.entrada,
                      onTap: () => setState(() => _filtroTipo = TipoTransacao.entrada),
                      corAtiva: AppColors.income,
                      count: totalEntradas,
                    ),
                    _buildFiltroChip(
                      label: 'Saídas',
                      selecionado: _filtroTipo == TipoTransacao.saida,
                      onTap: () => setState(() => _filtroTipo = TipoTransacao.saida),
                      corAtiva: AppColors.expense,
                      count: totalSaidas,
                    ),
                    _buildFiltroChip(
                      label: 'Fixos',
                      selecionado: _filtroTipo == TipoTransacao.fixo,
                      onTap: () => setState(() => _filtroTipo = TipoTransacao.fixo),
                      corAtiva: AppColors.fixed,
                      count: totalFixos,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            Expanded(
              child: lista.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              shape: BoxShape.circle,
                              boxShadow: AppColors.cardShadow,
                            ),
                            child: const Icon(
                              Icons.receipt_long_outlined,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhum lançamento encontrado',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Tente mudar o filtro ou adicione um novo.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                      itemCount: lista.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final t = lista[index];
                        final isEntrada = t.isEntrada;
                        final corValor = isEntrada ? AppColors.income : AppColors.expense;
                        final icone = _obterIconeCategoria(t.categoria);

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isEntrada
                                      ? AppColors.incomeLight
                                      : t.isFixo
                                          ? AppColors.fixedLight
                                          : AppColors.expenseLight,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  icone,
                                  size: 20,
                                  color: isEntrada
                                      ? AppColors.income
                                      : t.isFixo
                                          ? AppColors.fixed
                                          : AppColors.expense,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t.descricao,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Text(
                                          t.categoria,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        if (t.isFixo) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 1.5,
                                            ),
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
                                        ],
                                        const SizedBox(width: 6),
                                        Text(
                                          '• ${_formatarData(t.data)}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${isEntrada ? '+' : '-'} ${_formatarMoeda(t.valor)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: corValor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: AppColors.textMuted,
                                  size: 20,
                                ),
                                tooltip: 'Excluir',
                                onPressed: () => _excluirTransacao(t),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirNovoLancamento,
        backgroundColor: AppColors.primary,
        tooltip: 'Novo lançamento',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
