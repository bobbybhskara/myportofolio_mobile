import 'package:material_ui/material_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

void main() {
  const ownerName = 'Muhammad Eshan Bobby Bhaskara';
  const actionNames = ['Lihat Pengalaman', 'Tambah Pengalaman', 'Logout'];

  testWidgets('Shows the stateless portfolio home page', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.text('MyPortfolio'), findsOneWidget);
    expect(find.text('Selamat datang di MyPortfolio Mobile!'), findsOneWidget);
    for (final identity in const {
      'NPM': '2506546333',
      'Name': ownerName,
      'Class': 'PBP C',
    }.entries) {
      expect(
        find.descendant(
          of: find.widgetWithText(InfoCard, identity.key),
          matching: find.text(identity.value),
        ),
        findsOneWidget,
      );
    }
    expect(find.text('Lihat Pengalaman'), findsOneWidget);
    expect(find.text('Tambah Pengalaman'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
    expect(find.byIcon(Icons.work_outline), findsOneWidget);
    expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);

    final theme = Theme.of(tester.element(find.byType(MyHomePage)));
    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.secondary, Colors.amber.shade700);
  });

  testWidgets('Action cards have distinct readable backgrounds', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final backgrounds = <Color>{};

    for (final name in actionNames) {
      final card = find.widgetWithText(ItemCard, name);
      final background = tester
          .widget<Material>(
            find.descendant(of: card, matching: find.byType(Material)),
          )
          .color;
      final foreground = tester.widget<Text>(find.text(name)).style?.color;
      expect(background, isNotNull, reason: name);
      expect(foreground, isNotNull, reason: name);

      backgrounds.add(background!);
      final luminances = [
        background.computeLuminance(),
        foreground!.computeLuminance(),
      ]..sort();
      final contrast = (luminances.last + 0.05) / (luminances.first + 0.05);
      expect(contrast, greaterThanOrEqualTo(4.5), reason: name);
    }
    expect(backgrounds, hasLength(actionNames.length));
  });

  testWidgets('Every action card shows its own SnackBar', (tester) async {
    await tester.pumpWidget(const MyApp());

    for (final name in actionNames) {
      await tester.tap(find.text(name));
      await tester.pumpAndSettle();

      expect(find.text('Kamu telah menekan tombol $name!'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    }
  });

  testWidgets('Rapid taps replace queued SnackBars with the latest action', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Lihat Pengalaman'));
    await tester.pumpAndSettle();
    expect(
      find.text('Kamu telah menekan tombol Lihat Pengalaman!'),
      findsOneWidget,
    );

    await tester.tap(find.text('Tambah Pengalaman'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Kamu telah menekan tombol Logout!'), findsOneWidget);
    expect(
      find.text('Kamu telah menekan tombol Lihat Pengalaman!'),
      findsNothing,
    );
    expect(
      find.text('Kamu telah menekan tombol Tambah Pengalaman!'),
      findsNothing,
    );
    expect(find.byType(SnackBar), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsNothing);
  });

  for (final viewport in const {
    'narrow screen': Size(320, 568),
    'short screen': Size(640, 320),
  }.entries) {
    testWidgets('Full identity and all actions fit a ${viewport.key}', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(viewport.value);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const MyApp());

      expect(find.text('2506546333'), findsOneWidget);
      expect(find.text(ownerName), findsOneWidget);
      expect(find.text('PBP C'), findsOneWidget);
      final nameParagraph = tester.renderObject<RenderParagraph>(
        find.text(ownerName),
      );
      expect(nameParagraph.didExceedMaxLines, isFalse);

      for (final name in actionNames) {
        await tester.ensureVisible(find.text(name));
        await tester.tap(find.text(name));
        await tester.pumpAndSettle();

        expect(find.text('Kamu telah menekan tombol $name!'), findsOneWidget);
        expect(find.byType(SnackBar), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  }
}
