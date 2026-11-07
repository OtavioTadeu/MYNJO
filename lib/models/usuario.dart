// Otavio Tadeu
class Usuario {
  String nome;
  String email;
  String senha;

  Usuario({
    required this.nome,
    required this.email,
    required this.senha,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nome: json['nome'] as String? ?? '',
      email: json['email'] as String? ?? '',
      senha: json['senha'] as String? ?? '',
    );
  }
}

final List<Usuario> usuariosPadrao = [
  Usuario(
    nome: 'Administrador',
    email: 'admin@mynjo.com',
    senha: 'admin',
  ),
  Usuario(
    nome: 'Usuário Teste',
    email: 'teste@mynjo.com',
    senha: '123456',
  ),
];

List<Usuario> usuariosCadastrados = List.from(usuariosPadrao);
