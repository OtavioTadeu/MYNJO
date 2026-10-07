import 'package:flutter/material.dart';
import '../models/usuario.dart';
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

  final _emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _entrar() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final senha = _senhaController.text;

      // Procura o usuário na lista em memória
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
            content: Text('Bem-vindo(a), ${usuarioEncontrado.nome}!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navega para a tela inicial
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TelaInicio(usuario: usuarioEncontrado),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-mail ou senha inválidos!'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  size: 64,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                const Text(
                  'MYNJO Cash',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'Digite seu e-mail',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
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
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Digite sua senha',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite sua senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _entrar,
                  child: const Text('Entrar'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _irParaCadastro,
                  child: const Text('Não tem uma conta? Cadastre-se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}