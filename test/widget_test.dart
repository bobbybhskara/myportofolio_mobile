import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  testWidgets('Shows the stateless portfolio home page', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Halo dari MyPortfolio!'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);

    final theme = Theme.of(tester.element(find.byType(MyHomePage)));
    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.secondary, Colors.amber.shade700);
  });
}
