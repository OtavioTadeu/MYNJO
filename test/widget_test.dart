import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mynjo/main.dart';

void main() {
  testWidgets('Verifica renderização da tela de login', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MYNJO Cash'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
