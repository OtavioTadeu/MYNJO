import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../theme/app_colors.dart';
import '../utils/app_dimensions.dart';
import 'cadastro.dart';
import 'inicio.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _obscureSenha = true;
  bool _isLoading = false;

  final _emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _entrar() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final email = _emailController.text.trim();
      final senha = _senhaController.text;

      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        setState(() => _isLoading = false);

        final usuarioEncontrado = usuariosCadastrados.cast<Usuario?>().firstWhere(
              (u) =>
                  u != null &&
                  u.email.toLowerCase() == email.toLowerCase() &&
                  u.senha == senha,
              orElse: () => null,
            );

        if (usuarioEncontrado != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text('Bem-vindo(a), ${usuarioEncontrado.nome}!'),
                ],
              ),
              backgroundColor: AppColors.income,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TelaInicio(usuario: usuarioEncontrado),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text('E-mail ou senha inválidos!'),
                ],
              ),
              backgroundColor: AppColors.expense,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      });
    }
  }

  void _irParaCadastro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TelaCadastro(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; // Padding de 10% para telas com mais de 425 pixels lógico de largura

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: bottomInset > 0 ? bottomInset + 20 : 32,) +

          EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingHorizontal(context), //Padding horizontal
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(38),
                ),
              ),
              padding: const EdgeInsets.only(
                left: 24,
                top: 64,
                right: 24,
                bottom: 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'MYNJO Cash',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Seu dinheiro, sob controle.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -22),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppColors.cardShadow,
                  ),
                  padding: const EdgeInsets.all(22),
                  child: Form(
                    key: _formKey,
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
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 22),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'E-mail',
                            hintText: 'voce@email.com',
                            prefixIcon: Icon(Icons.alternate_email_rounded, size: 20),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Digite seu e-mail';
                            }
                            if (!_emailRegEx.hasMatch(value.trim())) {
                              return 'E-mail inválido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _senhaController,
                          obscureText: _obscureSenha,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            hintText: '••••••',
                            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureSenha
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() => _obscureSenha = !_obscureSenha);
                              },
                            ),
                          ),
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
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: AppColors.fabShadow,
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _entrar,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.4,
                                    ),
                                  )
                                : const Text('Entrar'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Não tem uma conta?',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: _irParaCadastro,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
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