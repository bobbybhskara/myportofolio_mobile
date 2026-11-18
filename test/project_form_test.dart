import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/project_form.dart';

void main() {
  testWidgets('Project name and description reject empty or whitespace input', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));

    for (final value in ['', '   ']) {
      await tester.enterText(find.byKey(const ValueKey('project-name')), value);
      await tester.enterText(
        find.byKey(const ValueKey('project-description')),
        value,
      );
      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
      expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
    }
  });

  testWidgets('Required fields are enough to confirm and reset the form', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    await tester.enterText(
      find.byKey(const ValueKey('project-name')),
      'My Portfolio',
    );
    await tester.enterText(
      find.byKey(const ValueKey('project-description')),
      'A Flutter portfolio.',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Proyek berhasil ditambahkan!'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('My Portfolio'), findsNothing);
    expect(find.text('A Flutter portfolio.'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
