// Marcus Vinicius

class Preferencias {
  // Tela inicial
  bool ocultarSaldoAoEntrar;
  bool mostrarSomenteFavoritas;

  // Relatório
  String moedaPadrao;
  int periodoPadrao;

  // Extrato
  bool confirmarAntesDeExcluir;

  Preferencias({
    this.ocultarSaldoAoEntrar = false,
    this.mostrarSomenteFavoritas = true,
    this.moedaPadrao = 'USD',
    this.periodoPadrao = 7,
    this.confirmarAntesDeExcluir = true,
  });
}

Preferencias preferencias = Preferencias();