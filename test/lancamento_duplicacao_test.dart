import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mynjo/dados/app_dados.dart';
import 'package:mynjo/models/usuario.dart';
import 'package:mynjo/screens/extrato_lancamento.dart';
import 'package:mynjo/screens/inicio.dart';

void main() {
  testWidgets('Criar lançamento a partir da TelaInicio não duplica a transação',
      (WidgetTester tester) async {
    final dados = AppDados();
    final quantidadeInicial = dados.transacoes.length;

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: dados,
        child: MaterialApp(
          home: TelaInicio(
            usuario: Usuario(
              nome: 'Teste User',
              email: 'teste@email.com',
              senha: '123',
            ),
          ),
        ),
      ),
    );

    // Clica no botão de ação rápida 'Entrada'
    final botaoEntrada = find.text('Entrada');
    expect(botaoEntrada, findsOneWidget);
    await tester.tap(botaoEntrada);
    await tester.pumpAndSettle();

    // Preenche a descrição e valor
    final campoDescricao = find.widgetWithText(TextFormField, 'Descrição');
    final campoValor = find.widgetWithText(TextFormField, 'Valor (R\$)');

    await tester.enterText(campoDescricao, 'Freelance Único');
    await tester.enterText(campoValor, '250.00');

    // Clica no botão 'Salvar Lançamento'
    final botaoSalvar = find.text('Salvar Lançamento');
    await tester.tap(botaoSalvar);
    await tester.pumpAndSettle();

    // Verifica que voltou para a TelaInicio
    expect(find.text('Freelance Único'), findsOneWidget);

    // Deve ter exatamente 1 transação a mais e exatamente uma ocorrência da transação criada
    expect(dados.transacoes.length, quantidadeInicial + 1);
    expect(dados.transacoes.where((t) => t.descricao == 'Freelance Único').length, 1);
  });

  testWidgets('Criar lançamento a partir da TelaExtratoLancamento não duplica a transação',
      (WidgetTester tester) async {
    final dados = AppDados();
    final quantidadeInicial = dados.transacoes.length;

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: dados,
        child: const MaterialApp(
          home: TelaExtratoLancamento(),
        ),
      ),
    );

    // Clica no botão '+' da AppBar para adicionar lançamento
    final botaoAdicionar = find.byIcon(Icons.add);
    expect(botaoAdicionar, findsOneWidget);
    await tester.tap(botaoAdicionar);
    await tester.pumpAndSettle();

    // Preenche a descrição e valor
    final campoDescricao = find.widgetWithText(TextFormField, 'Descrição');
    final campoValor = find.widgetWithText(TextFormField, 'Valor (R\$)');

    await tester.enterText(campoDescricao, 'Mercado Sem Duplicar');
    await tester.enterText(campoValor, '120.00');

    // Clica no botão 'Salvar Lançamento'
    final botaoSalvar = find.text('Salvar Lançamento');
    await tester.tap(botaoSalvar);
    await tester.pumpAndSettle();

    // Deve ter exatamente 1 transação a mais e exatamente uma ocorrência da transação criada
    expect(dados.transacoes.length, quantidadeInicial + 1);
    expect(dados.transacoes.where((t) => t.descricao == 'Mercado Sem Duplicar').length, 1);
  });
}

