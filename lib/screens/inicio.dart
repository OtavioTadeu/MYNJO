import 'package:flutter/material.dart';
import '../models/moeda.dart';
import '../models/transacao.dart';
import '../models/usuario.dart';
import '../theme/app_colors.dart';
import 'extrato_lancamento.dart';
import 'lancamento.dart';
import 'login.dart';
import 'relatorio.dart';

class TelaInicio extends StatefulWidget {
  final Usuario? usuario;

  const TelaInicio({super.key, this.usuario});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  bool _ocultarSaldo = false;
  late List<Transacao> _transacoes;
  late List<MoedaCotacao> _moedas;

  @override
  void initState() {
    super.initState();
    _transacoes = List.from(transacoesExemplo);
    _moedas = List.from(moedasPadrao);
  }

  double get _totalEntradas => _transacoes
      .where((t) => t.isEntrada)
      .fold(0.0, (acc, t) => acc + t.valor);

  double get _totalSaidas => _transacoes
      .where((t) => !t.isEntrada)
      .fold(0.0, (acc, t) => acc + t.valor);

  double get _saldoTotal => _totalEntradas - _totalSaidas;

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

  String _formatarData(DateTime data) {
    const meses = [
      'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
      'jul', 'ago', 'set', 'out', 'nov', 'dez'
    ];
    final dia = data.day.toString().padLeft(2, '0');
    final mes = meses[data.month - 1];
    return '$dia $mes';
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

  void _abrirLancamento([TipoTransacao? tipo]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaLancamento(tipoInicial: tipo),
      ),
    );
    setState(() {
      _transacoes = List.from(transacoesExemplo);
    });
  }

  void _abrirExtrato() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaExtratoLancamento(),
      ),
    );
    setState(() {
      _transacoes = List.from(transacoesExemplo);
    });
  }

  void _abrirRelatorio() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaRelatorio(),
      ),
    );
    setState(() {
      _transacoes = List.from(transacoesExemplo);
    });
  }

  void _confirmarLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sair do MYNJO Cash?'),
        content: const Text('Você precisará entrar com seu e-mail e senha novamente.'),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TelaLogin()),
              );
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nomeUsuario = widget.usuario?.nome.split(' ').first ?? 'Usuário';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'MYNJO Cash',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Extrato',
            icon: const Icon(Icons.receipt_long_rounded, color: AppColors.textSecondary),
            onPressed: _abrirExtrato,
          ),
          IconButton(
            tooltip: 'Relatório',
            icon: const Icon(Icons.pie_chart_outline_rounded, color: AppColors.textSecondary),
            onPressed: _abrirRelatorio,
          ),
          IconButton(
            tooltip: 'Sair da conta',
            icon: const Icon(Icons.logout_rounded, color: AppColors.textSecondary),
            onPressed: _confirmarLogout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppColors.fabShadow,
              ),
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Olá, $nomeUsuario 👋',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() => _ocultarSaldo = !_ocultarSaldo);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: _ocultarSaldo ? 'Mostrar saldo' : 'Ocultar saldo',
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _ocultarSaldo
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'SALDO ATUAL',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _ocultarSaldo ? 'R\$ ••••••••' : _formatarMoeda(_saldoTotal),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Entradas no mês',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _ocultarSaldo ? '••••' : _formatarMoeda(_totalEntradas),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saídas no mês',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _ocultarSaldo ? '••••' : _formatarMoeda(_totalSaidas),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildAcaoRapida(
                  label: 'Entrada',
                  icon: Icons.south_west_rounded,
                  corIcon: AppColors.income,
                  fundoIcon: AppColors.incomeLight,
                  onTap: () => _abrirLancamento(TipoTransacao.entrada),
                ),
                const SizedBox(width: 12),
                _buildAcaoRapida(
                  label: 'Saída',
                  icon: Icons.north_east_rounded,
                  corIcon: AppColors.expense,
                  fundoIcon: AppColors.expenseLight,
                  onTap: () => _abrirLancamento(TipoTransacao.saida),
                ),
                const SizedBox(width: 12),
                _buildAcaoRapida(
                  label: 'Gasto fixo',
                  icon: Icons.repeat_rounded,
                  corIcon: AppColors.fixed,
                  fundoIcon: AppColors.fixedLight,
                  onTap: () => _abrirLancamento(TipoTransacao.fixo),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Moedas favoritas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'PTAX · Banco Central',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 115,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _moedas.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final moeda = _moedas[index];
                  final isPositivo = moeda.variacaoPercentual >= 0;

                  return Container(
                    width: 155,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              moeda.bandeira,
                              style: const TextStyle(fontSize: 20),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    moeda.favorita = !moeda.favorita;
                                  });
                                },
                                child: Icon(
                                  moeda.favorita ? Icons.star_rounded : Icons.star_outline_rounded,
                                  color: moeda.favorita ? AppColors.starGold : AppColors.textMuted,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${moeda.codigo} · ${moeda.nome}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'R\$ ${moeda.valorVenda.toStringAsFixed(moeda.valorVenda < 1 ? 3 : 2)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: isPositivo
                                    ? AppColors.incomeLight
                                    : AppColors.expenseLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${isPositivo ? '▲' : '▼'} ${moeda.variacaoPercentual.abs()}%',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: isPositivo ? AppColors.income : AppColors.expense,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Últimos lançamentos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: _abrirExtrato,
                  child: Text('Ver todos (${_transacoes.length})'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _transacoes.take(5).length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final t = _transacoes[index];
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
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirLancamento(),
        tooltip: 'Novo lançamento',
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAcaoRapida({
    required String label,
    required IconData icon,
    required Color corIcon,
    required Color fundoIcon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: fundoIcon,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: corIcon, size: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
