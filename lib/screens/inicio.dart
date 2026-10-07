import 'package:flutter/material.dart';
import '../models/usuario.dart';
import 'login.dart';

class TelaInicio extends StatelessWidget {
  final Usuario? usuario;

  const TelaInicio({super.key, this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MYNJO Cash'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TelaLogin()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_balance_wallet,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 16),
              Text(
                'Olá, ${usuario?.nome ?? "Usuário"}!',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Bem-vindo ao MYNJO Cash.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const TelaLogin()),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sair da Conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
