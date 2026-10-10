import 'package:flutter/material.dart';
import '../components/botao_principal.dart';
import '../components/cabecalho_gradiente.dart';
import '../components/campo_email.dart';
import '../components/campo_senha.dart';
import '../components/cartao_branco.dart';
import '../components/mensagens.dart';
import '../models/usuario.dart';
import '../theme/app_colors.dart';
import '../utils/app_dimensions.dart';
import 'cadastro.dart';
import 'inicio.dart';

// Marcus Vinicius
// Otavio Tadeu
// Joao Felix

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool carregando = false;

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  // Procura na lista um usuário com esse e-mail e senha.
  // Se não achar, retorna null.
  Usuario? buscarUsuario(String email, String senha) {
    for (Usuario usuario in usuariosCadastrados) {
      bool mesmoEmail = usuario.email.toLowerCase() == email.toLowerCase();
      bool mesmaSenha = usuario.senha == senha;
      if (mesmoEmail && mesmaSenha) {
        return usuario;
      }
    }
    return null;
  }

  void entrar() async {
    // se o formulário tiver erro, não faz nada
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      carregando = true;
    });

    // espera um pouquinho só para mostrar o carregando
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() {
      carregando = false;
    });

    String email = emailController.text.trim();
    String senha = senhaController.text;
    Usuario? usuario = buscarUsuario(email, senha);

    if (usuario == null) {
      mostrarMensagemErro(context, 'E-mail ou senha inválidos!');
      return;
    }

    mostrarMensagemSucesso(context, 'Bem-vindo(a), ${usuario.nome}!');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TelaInicio(usuario: usuario),
      ),
    );
  }

  void irParaCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TelaCadastro()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CabecalhoGradiente(
              titulo: 'MYNJO Cash',
              subtitulo: 'Seu dinheiro, sob controle.',
            ),
            Transform.translate(
              offset: const Offset(0, -22),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingHorizontal(context)), //padding horizontal
                child: CartaoBranco(
                  arredondamento: 22,
                  padding: const EdgeInsets.all(22),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Acessar conta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Informe seus dados para continuar',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 22),
                        CampoEmail(controller: emailController),
                        const SizedBox(height: 16),
                        CampoSenha(
                          controller: senhaController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Digite sua senha';
                            }
                            if (value.length < 6) {
                              return 'Mínimo de 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        BotaoPrincipal(
                          texto: 'Entrar',
                          carregando: carregando,
                          onPressed: entrar,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Não tem uma conta?',
                              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                            TextButton(
                              onPressed: irParaCadastro,
                              child: const Text('Cadastre-se'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}