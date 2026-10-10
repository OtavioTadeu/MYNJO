import 'package:flutter/material.dart';
import '../components/botao_principal.dart';
import '../components/mensagens.dart';
import '../models/transacao.dart';
import '../utils/formatadores.dart';
import '../utils/app_dimensions.dart';

// Marcus Vinicius
// Otavio Tadeu

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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // troca a vírgula por ponto para o Dart entender o número
    String valorTexto = _valorController.text.trim().replaceAll(',', '.');
    double valor = double.parse(valorTexto);

    Transacao novaTransacao = Transacao(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tipo: _tipoSelecionado,
      descricao: _descricaoController.text.trim(),
      valor: valor,
      categoria: _categoriaSelecionada,
      data: _dataSelecionada,
    );

    // coloca no começo da lista para aparecer primeiro
    transacoesExemplo.insert(0, novaTransacao);

    mostrarMensagemSucesso(context, 'Lançamento salvo com sucesso!');
    Navigator.pop(context, novaTransacao);
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
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: AppDimensions.paddingHorizontal(context)),
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
                    subtitle: Text(formatarDataCompleta(_dataSelecionada)),
                    trailing: TextButton(
                      onPressed: _selecionarData,
                      child: const Text('Alterar'),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BotaoPrincipal(
                  texto: 'Salvar Lançamento',
                  onPressed: _salvarLancamento,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
