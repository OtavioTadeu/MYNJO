import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/chip_filtro.dart';
import '../components/dialogo_confirmacao.dart';
import '../components/item_transacao.dart';
import '../components/mensagens.dart';
import '../dados/app_dados.dart';
import '../models/transacao.dart';
import '../theme/app_colors.dart';
import '../utils/dimensoes_tela.dart';
import 'lancamento.dart';

// Marcus Vinicius
// Otavio Tadeu
// Yuri Stiwart

class TelaExtratoLancamento extends StatefulWidget {
  const TelaExtratoLancamento({super.key});

  @override
  State<TelaExtratoLancamento> createState() => _TelaExtratoLancamentoState();
}

class _TelaExtratoLancamentoState extends State<TelaExtratoLancamento> {
  // null = mostrar todas
  TipoTransacao? filtro;

  // Retorna a lista de acordo com o filtro escolhido
  List<Transacao> pegarTransacoesFiltradas(List<Transacao> todas) {
    if (filtro == null) {
      return todas;
    }
    List<Transacao> resultado = [];
    for (Transacao t in todas) {
      if (t.tipo == filtro) {
        resultado.add(t);
      }
    }
    return resultado;
  }

  // Conta quantas transações existem de um tipo
  int contarPorTipo(List<Transacao> todas, TipoTransacao tipo) {
    int quantidade = 0;
    for (Transacao t in todas) {
      if (t.tipo == tipo) {
        quantidade++;
      }
    }
    return quantidade;
  }

  void abrirNovoLancamento() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaLancamento()),
    );
  }

  void excluirTransacao(Transacao transacao) {
    final dados = context.read<AppDados>();

    // se o usuário desativou a confirmação nas preferências, exclui direto
    if (!dados.preferencias.confirmarAntesDeExcluir) {
      dados.removerTransacao(transacao.id);
      mostrarMensagemSucesso(context, 'Lançamento excluído com sucesso.');
      return;
    }

    mostrarDialogoConfirmacao(
      context: context,
      titulo: 'Excluir Lançamento?',
      mensagem: 'Deseja realmente excluir "${transacao.descricao}"?',
      textoBotao: 'Excluir',
      aoConfirmar: () {
        dados.removerTransacao(transacao.id);
        mostrarMensagemSucesso(context, 'Lançamento excluído com sucesso.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dados = context.watch<AppDados>();
    List<Transacao> lista = pegarTransacoesFiltradas(dados.transacoes);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Extrato (${lista.length})'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ===== Filtros =====
            Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChipFiltro(
                      texto: 'Todas',
                      selecionado: filtro == null,
                      corAtiva: AppColors.primary,
                      quantidade: dados.transacoes.length,
                      onTap: () {
                        setState(() {
                          filtro = null;
                        });
                      },
                    ),
                    ChipFiltro(
                      texto: 'Entradas',
                      selecionado: filtro == TipoTransacao.entrada,
                      corAtiva: AppColors.income,
                      quantidade:
                          contarPorTipo(dados.transacoes, TipoTransacao.entrada),
                      onTap: () {
                        setState(() {
                          filtro = TipoTransacao.entrada;
                        });
                      },
                    ),
                    ChipFiltro(
                      texto: 'Saídas',
                      selecionado: filtro == TipoTransacao.saida,
                      corAtiva: AppColors.expense,
                      quantidade:
                          contarPorTipo(dados.transacoes, TipoTransacao.saida),
                      onTap: () {
                        setState(() {
                          filtro = TipoTransacao.saida;
                        });
                      },
                    ),
                    ChipFiltro(
                      texto: 'Fixos',
                      selecionado: filtro == TipoTransacao.fixo,
                      corAtiva: AppColors.fixed,
                      quantidade:
                          contarPorTipo(dados.transacoes, TipoTransacao.fixo),
                      onTap: () {
                        setState(() {
                          filtro = TipoTransacao.fixo;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.border),

            // ===== Lista dinâmica com ListView.builder =====
            Expanded(
              child: lista.isEmpty ? listaVazia() : listaDeTransacoes(lista),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirNovoLancamento,
        backgroundColor: AppColors.primary,
        tooltip: 'Novo lançamento',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget listaDeTransacoes(List<Transacao> lista) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 80) +
          EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingHorizontal(context)),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        Transacao t = lista[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ItemTransacao(
            transacao: t,
            onExcluir: () {
              excluirTransacao(t);
            },
          ),
        );
      },
    );
  }

  Widget listaVazia() {
    return Center(
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
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
