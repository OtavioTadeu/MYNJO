import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mynjo/dados/app_dados.dart';
import 'package:mynjo/models/transacao.dart';
import 'package:mynjo/models/usuario.dart';

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

  test('AppDados inicializa com entradas de R\$ 100,00 e saídas de R\$ 32,58', () async {
    final dados = AppDados();
    await dados.iniciar();

    expect(dados.totalEntradas, 100.0);
    expect(dados.totalSaidas, 32.58);
    expect(double.parse(dados.saldo.toStringAsFixed(2)), 67.42);
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

    // Tentativa de adicionar a mesma transação novamente não deve duplicar
    dados.adicionarTransacao(nova);
    expect(dados.transacoes.where((t) => t.id == 'teste-123').length, 1);
    expect(dados.totalEntradas, totalEntradasInicial + 500.0);

    dados.removerTransacao('teste-123');
    expect(dados.totalEntradas, totalEntradasInicial);
  });

  test('BancoDadosLocal persiste transações entre reinicializações do app', () async {
    // 1ª execução do app
    final appInstancia1 = AppDados();
    await appInstancia1.iniciar();

    final novaTransacao = Transacao(
      id: 'transacao-persistida-999',
      tipo: TipoTransacao.saida,
      descricao: 'Curso Flutter COTEMIG',
      valor: 350.0,
      categoria: 'Educação',
      data: DateTime.now(),
    );

    appInstancia1.adicionarTransacao(novaTransacao);
    expect(appInstancia1.transacoes.any((t) => t.id == 'transacao-persistida-999'), true);

    // Aguarda microtask para persistência
    await Future.delayed(const Duration(milliseconds: 50));

    // 2ª execução do app (reinicialização completa)
    final appInstancia2 = AppDados();
    await appInstancia2.iniciar();

    // A transação cadastrada na 1ª sessão deve estar presente
    expect(appInstancia2.transacoes.any((t) => t.id == 'transacao-persistida-999'), true);
    final encontrada = appInstancia2.transacoes.firstWhere((t) => t.id == 'transacao-persistida-999');
    expect(encontrada.descricao, 'Curso Flutter COTEMIG');
    expect(encontrada.valor, 350.0);
  });

  test('BancoDadosLocal persiste cadastro de novo usuário e sessão de login', () async {
    // 1ª execução do app
    final appInstancia1 = AppDados();
    await appInstancia1.iniciar();

    final novoUsuario = Usuario(
      nome: 'Aluno Cotemig',
      email: 'aluno@cotemig.br',
      senha: 'senhaSegura123',
    );

    expect(appInstancia1.emailExiste('aluno@cotemig.br'), false);
    await appInstancia1.cadastrarUsuario(novoUsuario);
    expect(appInstancia1.emailExiste('aluno@cotemig.br'), true);

    // Faz login com o usuário recém-criado
    final autenticado = appInstancia1.buscarUsuario('aluno@cotemig.br', 'senhaSegura123');
    expect(autenticado, isNotNull);
    await appInstancia1.registrarLogin(autenticado!);
    expect(appInstancia1.usuarioLogado?.email, 'aluno@cotemig.br');

    // 2ª execução do app (reinicialização completa)
    final appInstancia2 = AppDados();
    await appInstancia2.iniciar();

    // O usuário cadastrado deve continuar existindo no banco
    expect(appInstancia2.emailExiste('aluno@cotemig.br'), true);
    final usuarioRecuperado = appInstancia2.buscarUsuario('aluno@cotemig.br', 'senhaSegura123');
    expect(usuarioRecuperado, isNotNull);
    expect(usuarioRecuperado?.nome, 'Aluno Cotemig');

    // A sessão ativa também deve ter sido persistida
    expect(appInstancia2.usuarioLogado?.email, 'aluno@cotemig.br');

    // Logout limpa a sessão
    await appInstancia2.registrarLogout();
    expect(appInstancia2.usuarioLogado, isNull);

    // 3ª execução após logout
    final appInstancia3 = AppDados();
    await appInstancia3.iniciar();
    expect(appInstancia3.usuarioLogado, isNull);
  });
}

