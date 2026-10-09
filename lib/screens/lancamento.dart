import 'package:flutter/material.dart';
import '../models/transacao.dart';

class TelaLancamento extends StatefulWidget {
  final TipoTransacao? tipoInicial;

  const TelaLancamento({super.key, this.tipoInicial});

  @override
  State<TelaLancamento> createState() => _TelaLancamentoState();
}

class _TelaLancamentoState extends State<TelaLancamento> {
  final _formKey = GlobalKey<FormState>();

  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();

  late TipoTransacao _tipoSelecionado;
  late String _categoriaSelecionada;
  DateTime _dataSelecionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tipoSelecionado = widget.tipoInicial ?? TipoTransacao.saida;
    _categoriaSelecionada = categoriasDisponiveis.first;
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  void _salvarLancamento() {
    if (_formKey.currentState?.validate() ?? false) {
      final valorTexto = _valorController.text.trim().replaceAll(',', '.');
      final valor = double.tryParse(valorTexto) ?? 0.0;

      final novaTransacao = Transacao(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tipo: _tipoSelecionado,
        descricao: _descricaoController.text.trim(),
        valor: valor,
        categoria: _categoriaSelecionada,
        data: _dataSelecionada,
      );

      transacoesExemplo.insert(0, novaTransacao);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lançamento salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, novaTransacao);
    }
  }

  void _selecionarData() async {
    final dataEscolhida = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (dataEscolhida != null) {
      setState(() {
        _dataSelecionada = dataEscolhida;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Lançamento'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<TipoTransacao>(
                  initialValue: _tipoSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Transação',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: TipoTransacao.entrada,
                      child: Text('Entrada (Receita)'),
                    ),
                    DropdownMenuItem(
                      value: TipoTransacao.saida,
                      child: Text('Saída (Despesa)'),
                    ),
                    DropdownMenuItem(
                      value: TipoTransacao.fixo,
                      child: Text('Gasto Fixo'),
                    ),
                  ],
                  onChanged: (novo) {
                    if (novo != null) {
                      setState(() => _tipoSelecionado = novo);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Ex.: Supermercado, Salário',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe uma descrição';
                    }
                    if (value.trim().length < 3) {
                      return 'Descrição muito curta (mínimo 3 letras)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _valorController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Valor (R\$)',
                    hintText: '0.00',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o valor';
                    }
                    final valor = double.tryParse(value.trim().replaceAll(',', '.'));
                    if (valor == null || valor <= 0) {
                      return 'Informe um valor válido maior que zero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _categoriaSelecionada,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  items: categoriasDisponiveis.map((cat) {
                    return DropdownMenuItem(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (novo) {
                    if (novo != null) {
                      setState(() => _categoriaSelecionada = novo);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Data'),
                    subtitle: Text(
                      '${_dataSelecionada.day.toString().padLeft(2, '0')}/${_dataSelecionada.month.toString().padLeft(2, '0')}/${_dataSelecionada.year}',
                    ),
                    trailing: TextButton(
                      onPressed: _selecionarData,
                      child: const Text('Alterar'),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _salvarLancamento,
                  child: const Text('Salvar Lançamento'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
