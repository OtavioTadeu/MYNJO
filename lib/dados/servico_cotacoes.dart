import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/moeda.dart';

const String urlCotacoesAtuais =
    'https://economia.awesomeapi.com.br/last/USD-BRL,EUR-BRL,GBP-BRL,ARS-BRL,CAD-BRL,JPY-BRL,CHF-BRL';

class ServicoCotacoes {
  Future<List<MoedaCotacao>> buscarCotacoes({
    required List<MoedaCotacao> moedasBase,
    required Set<String> favoritos,
  }) async {
    final response = await http.get(Uri.parse(urlCotacoesAtuais));

    if (response.statusCode != 200) {
      throw Exception('Falha ao obter cotações: status ${response.statusCode}');
    }

    final Map<String, dynamic> dados = jsonDecode(response.body);
    final List<MoedaCotacao> atualizadas = [];

    for (final base in moedasBase) {
      final chave = '${base.codigo}BRL';
      double valor = base.valorVenda;
      double variacao = base.variacaoPercentual;

      if (dados.containsKey(chave)) {
        final item = dados[chave] as Map<String, dynamic>;
        final bidStr = item['bid']?.toString();
        final pctStr = item['pctChange']?.toString();

        if (bidStr != null) {
          valor = double.tryParse(bidStr) ?? valor;
        }
        if (pctStr != null) {
          variacao = double.tryParse(pctStr) ?? variacao;
        }
      }

      atualizadas.add(
        base.copyWith(
          valorVenda: valor,
          variacaoPercentual: variacao,
          favorita: favoritos.contains(base.codigo),
        ),
      );
    }

    return atualizadas;
  }

  Future<List<CotacaoHistorico>> buscarHistorico(String moeda, int dias) async {
    final url = 'https://economia.awesomeapi.com.br/json/daily/$moeda-BRL/$dias';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Falha ao obter histórico de cotações: status ${response.statusCode}');
    }

    final lista = jsonDecode(response.body) as List<dynamic>;
    final List<CotacaoHistorico> resultado = [];

    for (int i = 0; i < lista.length; i++) {
      final item = lista[i] as Map<String, dynamic>;
      final bid = double.tryParse(item['bid']?.toString() ?? '') ?? 0.0;
      final pct = double.tryParse(item['pctChange']?.toString() ?? '') ?? 0.0;

      DateTime data;
      if (item['timestamp'] != null) {
        final sec = int.tryParse(item['timestamp'].toString());
        data = sec != null
            ? DateTime.fromMillisecondsSinceEpoch(sec * 1000)
            : DateTime.now().subtract(Duration(days: i));
      } else {
        data = DateTime.now().subtract(Duration(days: i));
      }

      resultado.add(
        CotacaoHistorico(
          data: data,
          valor: bid,
          variacao: pct,
        ),
      );
    }

    return resultado;
  }
}
