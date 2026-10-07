import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mynjo/main.dart';

void main() {
  testWidgets('Verifica renderização da tela de login', (WidgetTester tester) async {
    // Constrói o app e dispara o frame.
    await tester.pumpWidget(const MyApp());

    // Verifica se os elementos essenciais da tela de login aparecem
    expect(find.text('MYNJO Cash'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
