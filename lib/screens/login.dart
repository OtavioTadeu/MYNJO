import 'package:flutter/material.dart';

class telaLogin extends StatefulWidget {
  const telaLogin({super.key});

  @override
  State<telaLogin> createState() => _telaLoginState();
}

class _telaLoginState extends State<telaLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Login Screen',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle login button press
              },
              child: const Text('Login'),
            ),
          ],
        ),
      )
    );

  }
}