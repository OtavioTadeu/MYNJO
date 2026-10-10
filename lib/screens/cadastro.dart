import 'package:flutter/material.dart';
import '../components/botao_principal.dart';
import '../components/cabecalho_gradiente.dart';
import '../components/campo_email.dart';
import '../components/campo_senha.dart';
import '../components/cartao_branco.dart';
import '../utils/dimensoes_tela.dart';
import '../components/mensagens.dart';
import '../models/usuario.dart';
import '../theme/app_colors.dart';

// Marcus Vinicius
// Otavio Tadeu
// Natan Silva

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmaSenhaController = TextEditingController();

  bool carregando = false;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmaSenhaController.dispose();
    super.dispose();
  }

  // Verifica se já existe alguém com esse e-mail
  bool emailJaCadastrado(String email) {
    for (Usuario usuario in usuariosCadastrados) {
      if (usuario.email.toLowerCase() == email.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  void cadastrar() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      carregando = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() {
      carregando = false;
    });

    String email = emailController.text.trim();

    if (emailJaCadastrado(email)) {
      mostrarMensagemErro(context, 'Este e-mail já está cadastrado!');
      return;
    }

    Usuario novoUsuario = Usuario(
      nome: nomeController.text.trim(),
      email: email,
      senha: senhaController.text,
    );
    usuariosCadastrados.add(novoUsuario);

    mostrarMensagemSucesso(context, 'Cadastro realizado com sucesso! Faça seu login.');
    Navigator.pop(context);
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
              titulo: 'Criar Conta',
              subtitulo: 'Crie sua conta em poucos segundos.',
              mostrarBotaoVoltar: true,
            ),
            Transform.translate(
              offset: const Offset(0, -22),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CartaoBranco(
                  arredondamento: 22,
                  padding: EdgeInsets.symmetric(vertical: 22, horizontal: AppDimensions.paddingHorizontal(context)),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Preencha seus dados',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Todos os campos são obrigatórios',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 22),
                        TextFormField(
                          controller: nomeController,
                          decoration: const InputDecoration(
                            labelText: 'Nome completo',
                            hintText: 'Seu nome',
                            prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Digite seu nome';
                            }
                            if (value.trim().length < 2) {
                              return 'Nome deve ter pelo menos 2 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CampoEmail(controller: emailController),
                        const SizedBox(height: 16),
                        CampoSenha(
                          controller: senhaController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Digite uma senha';
                            }
                            if (value.length < 6) {
                              return 'Mínimo de 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CampoSenha(
                          controller: confirmaSenhaController,
                          label: 'Confirmar Senha',
                          icone: Icons.lock_reset_rounded,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirme sua senha';
                            }
                            if (value != senhaController.text) {
                              return 'As senhas não coincidem';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        BotaoPrincipal(
                          texto: 'Criar Minha Conta',
                          carregando: carregando,
                          onPressed: cadastrar,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Já possui uma conta?',
                              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Entrar'),
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
