import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mynjo/dados/app_dados.dart';
import 'package:mynjo/models/transacao.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'pref_ocultar_saldo': false,
      'pref_somente_favoritas': true,
      'pref_moeda_padrao': 'EUR',
      'pref_periodo_padrao': 15,
      'pref_confirmar_exclusao': false,
      'pref_moedas_favoritas': ['USD', 'EUR', 'GBP'],
    });
  });

  test('AppDados inicializa lendo SharedPreferences corretamente', () async {
    final dados = AppDados();
    await dados.iniciar();

    expect(dados.preferencias.moedaPadrao, 'EUR');
    expect(dados.preferencias.periodoPadrao, 15);
    expect(dados.preferencias.confirmarAntesDeExcluir, false);
    expect(dados.favoritos.contains('GBP'), true);
  });

  test('AppDados altera favoritos e persiste', () async {
    final dados = AppDados();
    await dados.iniciar();

    expect(dados.ehFavorita('ARS'), false);
    await dados.alternarFavorito('ARS');
    expect(dados.ehFavorita('ARS'), true);

    await dados.alternarFavorito('ARS');
    expect(dados.ehFavorita('ARS'), false);
  });

  test('AppDados adiciona e remove transações com cálculo correto de saldo', () {
    final dados = AppDados();
    final totalEntradasInicial = dados.totalEntradas;

    final nova = Transacao(
      id: 'teste-123',
      tipo: TipoTransacao.entrada,
      descricao: 'Bônus Teste',
      valor: 500.0,
      categoria: 'Salário',
      data: DateTime.now(),
    );

    dados.adicionarTransacao(nova);
    expect(dados.totalEntradas, totalEntradasInicial + 500.0);

    dados.removerTransacao('teste-123');
    expect(dados.totalEntradas, totalEntradasInicial);
  });
}
