import 'package:flutter/foundation.dart';
import '../models/moeda.dart';
import '../models/preferencias.dart';
import '../models/transacao.dart';
import 'servico_cotacoes.dart';
import 'servico_preferencias.dart';

class AppDados extends ChangeNotifier {
  final ServicoCotacoes _servicoCotacoes;
  final ServicoPreferencias _servicoPreferencias;

  AppDados({
    ServicoCotacoes? servicoCotacoes,
    ServicoPreferencias? servicoPreferencias,
  })  : _servicoCotacoes = servicoCotacoes ?? ServicoCotacoes(),
        _servicoPreferencias = servicoPreferencias ?? ServicoPreferencias() {
    _moedas = List.from(moedasPadrao);
    _transacoes = List.from(transacoesExemplo);
  }

  late List<MoedaCotacao> _moedas;
  Set<String> _favoritos = {'USD', 'EUR'};
  Preferencias _preferencias = Preferencias();
  late List<Transacao> _transacoes;
  List<CotacaoHistorico> _historicoCotacoes = [];

  bool _carregando = false;
  String? _erro;

  bool _carregandoHistorico = false;
  String? _erroHistorico;

  // Getters
  List<MoedaCotacao> get moedas => _moedas;
  Set<String> get favoritos => _favoritos;
  Preferencias get preferencias => _preferencias;
  List<Transacao> get transacoes => _transacoes;
  List<CotacaoHistorico> get historicoCotacoes => _historicoCotacoes;

  bool get carregando => _carregando;
  String? get erro => _erro;

  bool get carregandoHistorico => _carregandoHistorico;
  String? get erroHistorico => _erroHistorico;

  bool ehFavorita(String codigo) => _favoritos.contains(codigo);

  List<MoedaCotacao> get moedasParaExibir {
    if (!_preferencias.mostrarSomenteFavoritas) {
      return _moedas;
    }
    return _moedas.where((m) => m.favorita).toList();
  }

  List<MoedaCotacao> get moedasFavoritas =>
      _moedas.where((m) => m.favorita).toList();

  double get totalEntradas {
    double total = 0;
    for (final t in _transacoes) {
      if (t.isEntrada) total += t.valor;
    }
    return total;
  }

  double get totalSaidas {
    double total = 0;
    for (final t in _transacoes) {
      if (!t.isEntrada) total += t.valor;
    }
    return total;
  }

  double get saldo => totalEntradas - totalSaidas;

  // Inicialização (carrega preferências, favoritos salvos e busca API REST)
  Future<void> iniciar() async {
    _preferencias = await _servicoPreferencias.carregarPreferencias();
    _favoritos = await _servicoPreferencias.carregarFavoritos();

    // Sincroniza a instância global legado para compatibilidade
    _sincronizarPreferenciasGlobais();

    // Aplica favoritos nas moedas
    _moedas = _moedas.map((m) {
      return m.copyWith(favorita: _favoritos.contains(m.codigo));
    }).toList();

    notifyListeners();

    await carregarCotacoes();
  }

  // Busca cotações da API REST (com loading e erro)
  Future<void> carregarCotacoes() async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final atualizadas = await _servicoCotacoes.buscarCotacoes(
        moedasBase: _moedas,
        favoritos: _favoritos,
      );
      _moedas = atualizadas;
    } catch (_) {
      _erro = 'Não foi possível atualizar as cotações em tempo real.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  // Alterna favorito de uma moeda e persiste no SharedPreferences
  Future<void> alternarFavorito(String codigo) async {
    if (_favoritos.contains(codigo)) {
      _favoritos.remove(codigo);
    } else {
      _favoritos.add(codigo);
    }

    _moedas = _moedas.map((m) {
      if (m.codigo == codigo) {
        return m.copyWith(favorita: _favoritos.contains(codigo));
      }
      return m;
    }).toList();

    notifyListeners();
    await _servicoPreferencias.salvarFavoritos(_favoritos);
  }

  // Atualiza preferências e persiste no SharedPreferences
  Future<void> atualizarPreferencias({
    bool? ocultarSaldoAoEntrar,
    bool? mostrarSomenteFavoritas,
    bool? confirmarAntesDeExcluir,
    String? moedaPadrao,
    int? periodoPadrao,
  }) async {
    _preferencias = Preferencias(
      ocultarSaldoAoEntrar:
          ocultarSaldoAoEntrar ?? _preferencias.ocultarSaldoAoEntrar,
      mostrarSomenteFavoritas:
          mostrarSomenteFavoritas ?? _preferencias.mostrarSomenteFavoritas,
      confirmarAntesDeExcluir:
          confirmarAntesDeExcluir ?? _preferencias.confirmarAntesDeExcluir,
      moedaPadrao: moedaPadrao ?? _preferencias.moedaPadrao,
      periodoPadrao: periodoPadrao ?? _preferencias.periodoPadrao,
    );

    _sincronizarPreferenciasGlobais();
    notifyListeners();
    await _servicoPreferencias.salvarPreferencias(_preferencias);
  }

  void _sincronizarPreferenciasGlobais() {
    preferencias.ocultarSaldoAoEntrar = _preferencias.ocultarSaldoAoEntrar;
    preferencias.mostrarSomenteFavoritas =
        _preferencias.mostrarSomenteFavoritas;
    preferencias.moedaPadrao = _preferencias.moedaPadrao;
    preferencias.periodoPadrao = _preferencias.periodoPadrao;
    preferencias.confirmarAntesDeExcluir =
        _preferencias.confirmarAntesDeExcluir;
  }

  // Busca histórico de cotações para a tela de relatório
  Future<void> carregarHistorico(String moeda, int dias) async {
    _carregandoHistorico = true;
    _erroHistorico = null;
    _historicoCotacoes = [];
    notifyListeners();

    try {
      final lista = await _servicoCotacoes.buscarHistorico(moeda, dias);
      _historicoCotacoes = lista;
    } catch (_) {
      _erroHistorico =
          'Não foi possível carregar as cotações. Verifique sua conexão e tente novamente.';
    } finally {
      _carregandoHistorico = false;
      notifyListeners();
    }
  }

  // Adicionar e remover lançamentos
  void adicionarTransacao(Transacao transacao) {
    _transacoes.insert(0, transacao);
    notifyListeners();
  }

  void removerTransacao(String id) {
    _transacoes.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}

