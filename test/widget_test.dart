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
    expect(find.text('2506546333'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Muhammad Eshan Bobby Bhaskara'), findsOneWidget);
    expect(find.text('Class'), findsOneWidget);
    expect(find.text('PBP C'), findsOneWidget);
    expect(find.text('Lihat Pengalaman'), findsOneWidget);
    expect(find.text('Tambah Pengalaman'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
    expect(find.byIcon(Icons.work_outline), findsOneWidget);
    expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);

    final theme = Theme.of(tester.element(find.byType(MyHomePage)));
    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.secondary, Colors.amber.shade700);

    final backgrounds = tester
        .widgetList<Material>(
          find.descendant(
            of: find.byType(ItemCard),
            matching: find.byType(Material),
          ),
        )
        .map((material) => material.color)
        .toSet();
    expect(backgrounds, hasLength(3));
    expect(backgrounds, isNot(contains(null)));
  });

  testWidgets('Owner and action cards fit a narrow screen', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MyApp());

    expect(find.text('2506546333'), findsOneWidget);
    expect(find.text('Muhammad Eshan Bobby Bhaskara'), findsOneWidget);
    expect(find.text('PBP C'), findsOneWidget);
    expect(find.text('Tambah Pengalaman'), findsOneWidget);
    await tester.ensureVisible(find.text('Tambah Pengalaman'));
    await tester.tap(find.text('Tambah Pengalaman'));
    await tester.pumpAndSettle();

    expect(
      find.text('Kamu telah menekan tombol Tambah Pengalaman!'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Every action card shows its own SnackBar', (tester) async {
    await tester.pumpWidget(const MyApp());

    for (final name in ['Lihat Pengalaman', 'Tambah Pengalaman', 'Logout']) {
      await tester.tap(find.text(name));
      await tester.pumpAndSettle();

      expect(find.text('Kamu telah menekan tombol $name!'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    }
  });

  testWidgets('Action cards remain reachable on a short screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(640, 320));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MyApp());
    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
