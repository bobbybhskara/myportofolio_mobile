import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/menu.dart';

void main() {
  testWidgets('Shows the stateless portfolio home page', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
    expect(find.text('NPM'), findsOneWidget);
    expect(find.text('2406000001'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Burhan'), findsOneWidget);
    expect(find.text('Class'), findsOneWidget);
    expect(find.text('PBP A'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);

    final theme = Theme.of(tester.element(find.byType(MyHomePage)));
    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.secondary, Colors.amber.shade700);
  });

  testWidgets('Owner cards fit a narrow screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MyApp());

    expect(find.text('2406000001'), findsOneWidget);
    expect(find.text('Burhan'), findsOneWidget);
    expect(find.text('PBP A'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
