import 'package:flutter/material.dart';
import '../components/botao_acao_rapida.dart';
import '../components/card_moeda.dart';
import '../components/cartao_branco.dart';
import '../components/item_transacao.dart';
import '../components/titulo_secao.dart';
import '../models/moeda.dart';
import '../models/preferencias.dart';
import '../models/transacao.dart';
import '../models/usuario.dart';
import '../theme/app_colors.dart';
import '../utils/app_dimensions.dart';
import '../utils/formatadores.dart';
import 'extrato_lancamento.dart';
import 'lancamento.dart';
import 'perfil.dart';
import 'relatorio.dart';

// Marcus Vinicius
// Otavio Tadeu

class TelaInicio extends StatefulWidget {
  final Usuario? usuario;

  const TelaInicio({super.key, this.usuario});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  bool _ocultarSaldo = true;
  late List<Transacao> _transacoes;
  late List<MoedaCotacao> _moedas;
  bool ocultarSaldo = false;

  @override
  void initState() {
    super.initState();
    // usa o que o usuário escolheu nas preferências
    ocultarSaldo = preferencias.ocultarSaldoAoEntrar;
  }

  // soma todas as entradas
  double calcularTotalEntradas() {
    double total = 0;
    for (Transacao t in transacoesExemplo) {
      if (t.isEntrada) {
        total = total + t.valor;
      }
    }
    return total;
  }

  // soma todas as saídas (saídas normais + gastos fixos)
  double calcularTotalSaidas() {
    double total = 0;
    for (Transacao t in transacoesExemplo) {
      if (!t.isEntrada) {
        total = total + t.valor;
      }
    }
    return total;
  }

  // Abre outra tela e, quando voltar, atualiza esta tela
  void abrirTela(Widget tela) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => tela),
    );
    setState(() {});
  }

  // Retorna as moedas que vão aparecer na tela inicial
  List<MoedaCotacao> pegarMoedasParaMostrar() {
    if (!preferencias.mostrarSomenteFavoritas) {
      return moedasPadrao;
    }
    List<MoedaCotacao> favoritas = [];
    for (MoedaCotacao m in moedasPadrao) {
      if (m.favorita) {
        favoritas.add(m);
      }
    }
    return favoritas;
  }

  void abrirPerfil() {
    // se por algum motivo não tiver usuário, usa o primeiro da lista
    Usuario usuario = widget.usuario ?? usuariosCadastrados.first;
    abrirTela(TelaPerfil(usuario: usuario));
  }

  @override
  Widget build(BuildContext context) {
    String nomeUsuario = 'Usuário';
    if (widget.usuario != null) {
      nomeUsuario = widget.usuario!.nome.split(' ').first;
    }

    double totalEntradas = calcularTotalEntradas();
    double totalSaidas = calcularTotalSaidas();
    double saldo = totalEntradas - totalSaidas;

    // pega só as 5 primeiras transações
    List<Transacao> ultimasTransacoes = transacoesExemplo.take(5).toList();
    List<MoedaCotacao> moedasParaMostrar = pegarMoedasParaMostrar();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
            onPressed: () {
              abrirTela(const TelaExtratoLancamento());
            },
          ),
          IconButton(
            tooltip: 'Relatório',
            icon: const Icon(Icons.pie_chart_outline_rounded, color: AppColors.textSecondary),
            onPressed: () {
              abrirTela(const TelaRelatorio());
            },
          ),
          IconButton(
            tooltip: 'Meu perfil',
            icon: const Icon(Icons.account_circle_outlined, color: AppColors.textSecondary),
            onPressed: abrirPerfil,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingHorizontal(context),
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== Cartão do saldo =====
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
                          setState(() {
                            ocultarSaldo = !ocultarSaldo;
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: ocultarSaldo ? 'Mostrar saldo' : 'Ocultar saldo',
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            ocultarSaldo
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
                    ocultarSaldo ? 'R\$ ••••••••' : formatarMoeda(saldo),
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
                        child: caixinhaResumo('Entradas no mês', totalEntradas),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: caixinhaResumo('Saídas no mês', totalSaidas),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ===== Ações rápidas =====
            Row(
              children: [
                Expanded(
                  child: BotaoAcaoRapida(
                    texto: 'Entrada',
                    icone: Icons.south_west_rounded,
                    corIcone: AppColors.income,
                    corFundoIcone: AppColors.incomeLight,
                    onTap: () {
                      abrirTela(const TelaLancamento(tipoInicial: TipoTransacao.entrada));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BotaoAcaoRapida(
                    texto: 'Saída',
                    icone: Icons.north_east_rounded,
                    corIcone: AppColors.expense,
                    corFundoIcone: AppColors.expenseLight,
                    onTap: () {
                      abrirTela(const TelaLancamento(tipoInicial: TipoTransacao.saida));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BotaoAcaoRapida(
                    texto: 'Gasto fixo',
                    icone: Icons.repeat_rounded,
                    corIcone: AppColors.fixed,
                    corFundoIcone: AppColors.fixedLight,
                    onTap: () {
                      abrirTela(const TelaLancamento(tipoInicial: TipoTransacao.fixo));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ===== Moedas =====
            TituloSecao(
              titulo: 'Moedas favoritas',
              direita: Text(
                'PTAX · Banco Central',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (moedasParaMostrar.isEmpty)
              semMoedasFavoritas()
            else
              SizedBox(
                height: 115,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: moedasParaMostrar.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    MoedaCotacao moeda = moedasParaMostrar[index];
                    return CardMoeda(
                      moeda: moeda,
                      onFavoritar: () {
                        setState(() {
                          moeda.favorita = !moeda.favorita;
                        });
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),

            // ===== Últimos lançamentos =====
            TituloSecao(
              titulo: 'Últimos lançamentos',
              direita: TextButton(
                onPressed: () {
                  abrirTela(const TelaExtratoLancamento());
                },
                child: Text('Ver todos (${transacoesExemplo.length})'),
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ultimasTransacoes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return ItemTransacao(transacao: ultimasTransacoes[index]);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          abrirTela(const TelaLancamento());
        },
        tooltip: 'Novo lançamento',
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Caixinha transparente dentro do cartão do saldo
  Widget caixinhaResumo(String titulo, double valor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ocultarSaldo ? '••••' : formatarMoeda(valor),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // Aparece quando o usuário não tem nenhuma moeda favorita
  Widget semMoedasFavoritas() {
    return CartaoBranco(
      arredondamento: 18,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.star_outline_rounded, color: AppColors.starGold, size: 28),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Você ainda não tem moedas favoritas.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              abrirTela(const TelaRelatorio());
            },
            child: const Text('Escolher'),
          ),
        ],
      ),
    );
  }
}
