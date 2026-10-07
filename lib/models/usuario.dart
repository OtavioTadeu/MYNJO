class Usuario {
  final String nome;
  final String email;
  final String senha;

  Usuario({
    required this.nome,
    required this.email,
    required this.senha,
  });
}

// Lista de usuários cadastrados em memória para testes e persistência durante a execução
final List<Usuario> usuariosCadastrados = [
  Usuario(
    nome: 'Usuário Teste',
    email: 'teste@mynjo.com',
    senha: '123456',
  ),
];
