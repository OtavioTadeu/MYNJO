import 'package:shared_preferences/shared_preferences.dart';
import '../models/preferencias.dart';

class ServicoPreferencias {
  static const String chaveOcultarSaldo = 'pref_ocultar_saldo';
  static const String chaveSomenteFavoritas = 'pref_somente_favoritas';
  static const String chaveMoedaPadrao = 'pref_moeda_padrao';
  static const String chavePeriodoPadrao = 'pref_periodo_padrao';
  static const String chaveConfirmarExclusao = 'pref_confirmar_exclusao';
  static const String chaveFavoritos = 'pref_moedas_favoritas';

  Future<Preferencias> carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();

    return Preferencias(
      ocultarSaldoAoEntrar: prefs.getBool(chaveOcultarSaldo) ?? false,
      mostrarSomenteFavoritas: prefs.getBool(chaveSomenteFavoritas) ?? true,
      moedaPadrao: prefs.getString(chaveMoedaPadrao) ?? 'USD',
      periodoPadrao: prefs.getInt(chavePeriodoPadrao) ?? 7,
      confirmarAntesDeExcluir: prefs.getBool(chaveConfirmarExclusao) ?? true,
    );
  }

  Future<void> salvarPreferencias(Preferencias preferencias) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(chaveOcultarSaldo, preferencias.ocultarSaldoAoEntrar);
    await prefs.setBool(
        chaveSomenteFavoritas, preferencias.mostrarSomenteFavoritas);
    await prefs.setString(chaveMoedaPadrao, preferencias.moedaPadrao);
    await prefs.setInt(chavePeriodoPadrao, preferencias.periodoPadrao);
    await prefs.setBool(
        chaveConfirmarExclusao, preferencias.confirmarAntesDeExcluir);
  }

  Future<Set<String>> carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(chaveFavoritos);
    if (lista == null) {
      return {'USD', 'EUR'};
    }
    return lista.toSet();
  }

  Future<void> salvarFavoritos(Set<String> favoritos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(chaveFavoritos, favoritos.toList());
  }
}
