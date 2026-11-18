import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

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

  testWidgets(
    'Dialog shows every input and resets category and optional fields',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
      for (final entry in {
        'project-name': 'Mobile Portfolio',
        'project-description': 'A portfolio application.',
        'project-technologies': 'Flutter, Django',
        'project-link': 'https://example.com/project',
      }.entries) {
        await tester.ensureVisible(find.byKey(ValueKey(entry.key)));
        await tester.enterText(find.byKey(ValueKey(entry.key)), entry.value);
      }
      await tester.ensureVisible(
        find.byKey(const ValueKey('project-category')),
      );
      await tester.tap(find.byKey(const ValueKey('project-category')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mobile Development').last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      for (final text in [
        'Nama Proyek: Mobile Portfolio',
        'Deskripsi: A portfolio application.',
        'Kategori: Mobile Development',
        'Teknologi: Flutter, Django',
        'Tautan: https://example.com/project',
      ]) {
        expect(find.text(text), findsOneWidget);
      }
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      for (final key in [
        'project-name',
        'project-description',
        'project-technologies',
        'project-link',
      ]) {
        final input = tester.widget<EditableText>(
          find.descendant(
            of: find.byKey(ValueKey(key)),
            matching: find.byType(EditableText),
          ),
        );
        expect(input.controller.text, isEmpty);
      }
      expect(find.text('Web Development'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('project-name')),
        'Second',
      );
      await tester.enterText(
        find.byKey(const ValueKey('project-description')),
        'Fresh input.',
      );
      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Kategori: Web Development'), findsOneWidget);
      expect(find.text('Teknologi: -'), findsOneWidget);
      expect(find.text('Tautan: -'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
