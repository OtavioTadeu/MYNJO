import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transacao.dart';
import '../models/usuario.dart';

class BancoDadosLocal {
  static const String chaveUsuarios = 'banco_usuarios';
  static const String chaveUsuarioLogado = 'banco_usuario_logado';
  static const String chaveTransacoes = 'banco_transacoes';

  // ===== USUÁRIOS =====

  Future<List<Usuario>> carregarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(chaveUsuarios);

    if (jsonString == null || jsonString.isEmpty) {
      final iniciais = List<Usuario>.from(usuariosPadrao);
      await salvarUsuarios(iniciais);
      return iniciais;
    }

    try {
      final List<dynamic> lista = jsonDecode(jsonString);
      final usuarios = lista
          .map((item) => Usuario.fromJson(item as Map<String, dynamic>))
          .toList();

      if (usuarios.isEmpty) {
        final iniciais = List<Usuario>.from(usuariosPadrao);
        await salvarUsuarios(iniciais);
        return iniciais;
      }
      return usuarios;
    } catch (_) {
      return List<Usuario>.from(usuariosPadrao);
    }
  }

  Future<void> salvarUsuarios(List<Usuario> usuarios) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(usuarios.map((u) => u.toJson()).toList());
    await prefs.setString(chaveUsuarios, jsonString);
  }

  // ===== SESSÃO / USUÁRIO LOGADO =====

  Future<Usuario?> carregarUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(chaveUsuarioLogado);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> mapa = jsonDecode(jsonString);
      return Usuario.fromJson(mapa);
    } catch (_) {
      return null;
    }
  }

  Future<void> salvarUsuarioLogado(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(usuario.toJson());
    await prefs.setString(chaveUsuarioLogado, jsonString);
  }

  Future<void> limparSessao() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(chaveUsuarioLogado);
  }

  // ===== TRANSAÇÕES / LANÇAMENTOS =====

  Future<List<Transacao>> carregarTransacoes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(chaveTransacoes);

    if (jsonString == null) {
      final iniciais = List<Transacao>.from(transacoesExemplo);
      await salvarTransacoes(iniciais);
      return iniciais;
    }

    if (jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> lista = jsonDecode(jsonString);
      return lista
          .map((item) => Transacao.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return List<Transacao>.from(transacoesExemplo);
    }
  }

  Future<void> salvarTransacoes(List<Transacao> transacoes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(transacoes.map((t) => t.toJson()).toList());
    await prefs.setString(chaveTransacoes, jsonString);
  }

  Future<void> limparBanco() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(chaveUsuarios);
    await prefs.remove(chaveUsuarioLogado);
    await prefs.remove(chaveTransacoes);
  }
}

