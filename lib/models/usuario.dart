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
}

final List<Usuario> usuariosCadastrados = [
  Usuario(
    nome: 'Usuário Teste',
    email: 'teste@mynjo.com',
    senha: '123456',
  ),
];
