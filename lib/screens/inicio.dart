import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/botao_acao_rapida.dart';
import '../components/card_moeda.dart';
import '../components/cartao_branco.dart';
import '../components/item_transacao.dart';
import '../components/titulo_secao.dart';
import '../dados/app_dados.dart';
import '../models/moeda.dart';
import '../models/transacao.dart';
import '../models/usuario.dart';
import '../theme/app_colors.dart';
import '../utils/dimensoes_tela.dart';
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
  bool ocultarSaldo = false;
  bool _preferenciaInicialCarregada = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final dados = context.read<AppDados>();
        if (!_preferenciaInicialCarregada) {
          setState(() {
            ocultarSaldo = dados.preferencias.ocultarSaldoAoEntrar;
            _preferenciaInicialCarregada = true;
          });
        }
      }
    });
  }

  // Abre outra tela e, quando voltar, se houver nova transação, atualiza
  void abrirTela(Widget tela) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => tela),
    );
    if (resultado is Transacao && mounted) {
      context.read<AppDados>().adicionarTransacao(resultado);
    }
  }

  void abrirPerfil() {
    Usuario usuario = widget.usuario ?? usuariosCadastrados.first;
    abrirTela(TelaPerfil(usuario: usuario));
  }

  @override
  Widget build(BuildContext context) {
    final dados = context.watch<AppDados>();

    String nomeUsuario = 'Usuário';
    if (widget.usuario != null) {
      nomeUsuario = widget.usuario!.nome.split(' ').first;
    }

    double totalEntradas = dados.totalEntradas;
    double totalSaidas = dados.totalSaidas;
    double saldo = dados.saldo;

    List<Transacao> ultimasTransacoes = dados.transacoes.take(5).toList();
    List<MoedaCotacao> moedasParaMostrar = dados.moedasParaExibir;

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
            icon: const Icon(Icons.receipt_long_rounded,
                color: AppColors.textSecondary),
            onPressed: () {
              abrirTela(const TelaExtratoLancamento());
            },
          ),
          IconButton(
            tooltip: 'Relatório',
            icon: const Icon(Icons.pie_chart_outline_rounded,
                color: AppColors.textSecondary),
            onPressed: () {
              abrirTela(const TelaRelatorio());
            },
          ),
          IconButton(
            tooltip: 'Meu perfil',
            icon: const Icon(Icons.account_circle_outlined,
                color: AppColors.textSecondary),
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
                        tooltip:
                            ocultarSaldo ? 'Mostrar saldo' : 'Ocultar saldo',
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
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ocultarSaldo ? 'R\$ ••••••' : formatarMoeda(saldo),
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
                        child: caixinhaResumo('Entradas', totalEntradas),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: caixinhaResumo('Saídas', totalSaidas),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ===== Botões de ação rápida =====
            Row(
              children: [
                Expanded(
                  child: BotaoAcaoRapida(
                    texto: 'Entrada',
                    icone: Icons.arrow_downward_rounded,
                    corIcone: AppColors.income,
                    corFundoIcone: AppColors.incomeLight,
                    onTap: () {
                      abrirTela(const TelaLancamento(
                          tipoInicial: TipoTransacao.entrada));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BotaoAcaoRapida(
                    texto: 'Saída',
                    icone: Icons.arrow_upward_rounded,
                    corIcone: AppColors.expense,
                    corFundoIcone: AppColors.expenseLight,
                    onTap: () {
                      abrirTela(const TelaLancamento(
                          tipoInicial: TipoTransacao.saida));
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
                      abrirTela(
                          const TelaLancamento(tipoInicial: TipoTransacao.fixo));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ===== Moedas =====
            TituloSecao(
              titulo: 'Cotações em tempo real',
              direita: dados.carregando
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      tooltip: 'Atualizar cotações',
                      icon: const Icon(Icons.refresh_rounded, size: 20),
                      onPressed: () => dados.carregarCotacoes(),
                    ),
            ),
            const SizedBox(height: 12),
            _secaoMoedas(dados, moedasParaMostrar),
            const SizedBox(height: 24),

            // ===== Últimos lançamentos =====
            TituloSecao(
              titulo: 'Últimos lançamentos',
              direita: TextButton(
                onPressed: () {
                  abrirTela(const TelaExtratoLancamento());
                },
                child: Text('Ver todos (${dados.transacoes.length})'),
              ),
            ),
            const SizedBox(height: 12),
            if (ultimasTransacoes.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Nenhum lançamento registrado.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              )
            else
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: ultimasTransacoes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ItemTransacao(
                      transacao: ultimasTransacoes[index],
                    ),
                  );
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

  Widget _secaoMoedas(AppDados dados, List<MoedaCotacao> moedasParaMostrar) {
    if (dados.carregando && dados.moedas.isEmpty) {
      return const SizedBox(
        height: 115,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (dados.erro != null && moedasParaMostrar.isEmpty) {
      return CartaoBranco(
        arredondamento: 18,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.expense, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                dados.erro!,
                style: const TextStyle(fontSize: 13, color: AppColors.expense),
              ),
            ),
            TextButton(
              onPressed: () => dados.carregarCotacoes(),
              child: const Text('Tentar de novo'),
            ),
          ],
        ),
      );
    }

    if (moedasParaMostrar.isEmpty) {
      return semMoedasFavoritas();
    }

    return SizedBox(
      height: 115,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: moedasParaMostrar.length,
        itemBuilder: (context, index) {
          MoedaCotacao moeda = moedasParaMostrar[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CardMoeda(
              moeda: moeda,
              onFavoritar: () {
                dados.alternarFavorito(moeda.codigo);
              },
            ),
          );
        },
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
          const Icon(Icons.star_outline_rounded,
              color: AppColors.starGold, size: 28),
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
