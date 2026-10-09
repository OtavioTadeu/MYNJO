import 'package:flutter/material.dart';
import '../models/transacao.dart';
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
        title: const Text('Excluir Lançamento?'),
        content: Text('Deseja realmente excluir "${transacao.descricao}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                transacoesExemplo.removeWhere((t) => t.id == transacao.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lançamento excluído com sucesso.'),
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
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  String _formatarValor(Transacao t) {
    final prefixo = t.isEntrada ? '+ ' : '- ';
    return '$prefixo R\$ ${t.valor.toStringAsFixed(2)}';
  }

  Color _corTipo(Transacao t) {
    if (t.isEntrada) return Colors.green;
    if (t.isFixo) return Colors.purple;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final lista = _transacoesFiltradas;

    return Scaffold(
      appBar: AppBar(
        title: Text('Extrato (${lista.length})'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() => _filtroTipo = null),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _filtroTipo == null ? Colors.blue : Colors.grey[300],
                        foregroundColor: _filtroTipo == null ? Colors.white : Colors.black87,
                      ),
                      child: const Text('Todas'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => setState(() => _filtroTipo = TipoTransacao.entrada),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _filtroTipo == TipoTransacao.entrada ? Colors.green : Colors.grey[300],
                        foregroundColor: _filtroTipo == TipoTransacao.entrada ? Colors.white : Colors.black87,
                      ),
                      child: const Text('Entradas'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => setState(() => _filtroTipo = TipoTransacao.saida),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _filtroTipo == TipoTransacao.saida ? Colors.red : Colors.grey[300],
                        foregroundColor: _filtroTipo == TipoTransacao.saida ? Colors.white : Colors.black87,
                      ),
                      child: const Text('Saídas'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => setState(() => _filtroTipo = TipoTransacao.fixo),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _filtroTipo == TipoTransacao.fixo ? Colors.purple : Colors.grey[300],
                        foregroundColor: _filtroTipo == TipoTransacao.fixo ? Colors.white : Colors.black87,
                      ),
                      child: const Text('Fixos'),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: lista.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Nenhum lançamento encontrado',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: lista.length,
                      itemBuilder: (context, index) {
                        final t = lista[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _corTipo(t).withValues(alpha: 0.2),
                              child: Icon(
                                t.isEntrada
                                    ? Icons.arrow_downward
                                    : t.isFixo
                                        ? Icons.repeat
                                        : Icons.arrow_upward,
                                color: _corTipo(t),
                              ),
                            ),
                            title: Text(
                              t.descricao,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('${t.categoria} • ${_formatarData(t.data)}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _formatarValor(t),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _corTipo(t),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.grey),
                                  onPressed: () => _excluirTransacao(t),
                                ),
                              ],
                            ),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
