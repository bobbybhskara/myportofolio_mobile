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

    await tester.enterText(
      find.byKey(const ValueKey('project-name')),
      'Valid name',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Nama proyek tidak boleh kosong!'), findsNothing);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('project-name')), '');
    await tester.enterText(
      find.byKey(const ValueKey('project-description')),
      'Valid description',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Nama proyek tidak boleh kosong!'), findsOneWidget);
    expect(find.text('Deskripsi proyek tidak boleh kosong!'), findsNothing);
    expect(find.byType(AlertDialog), findsNothing);
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

  testWidgets('Every category is available and appears in confirmation', (
    tester,
  ) async {
    const categories = [
      'Web Development',
      'Mobile Development',
      'Machine Learning',
      'Data Science',
      'Other',
    ];
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    final categoryField = find.byKey(const ValueKey('project-category'));
    for (final category in categories) {
      await tester.enterText(
        find.byKey(const ValueKey('project-name')),
        '  Portfolio  ',
      );
      await tester.enterText(
        find.byKey(const ValueKey('project-description')),
        '  My project.  ',
      );
      await tester.ensureVisible(categoryField);
      await tester.tap(categoryField);
      await tester.pumpAndSettle();
      for (final option in categories) {
        expect(find.text(option), findsWidgets);
      }
      await tester.ensureVisible(find.text(category).last);
      await tester.tap(find.text(category).last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save'));
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Kategori: $category'), findsOneWidget);
      expect(find.text('Nama Proyek: Portfolio'), findsOneWidget);
      expect(find.text('Deskripsi: My project.'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Save and confirmation remain reachable with keyboard insets', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(viewInsets: const EdgeInsets.only(bottom: 220)),
          child: child!,
        ),
        home: const ProjectFormPage(),
      ),
    );
    await tester.enterText(
      find.byKey(const ValueKey('project-name')),
      'Keyboard test',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('project-description')),
    );
    await tester.enterText(
      find.byKey(const ValueKey('project-description')),
      'The form scrolls above the keyboard.',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save'));
    await tester.pumpAndSettle();
    expect(tester.getRect(find.text('Save')).bottom, lessThan(348));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Dismissing confirmation preserves the form for editing', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));
    await tester.enterText(
      find.byKey(const ValueKey('project-name')),
      'Draft project',
    );
    await tester.enterText(
      find.byKey(const ValueKey('project-description')),
      'Still editing.',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.byType(AlertDialog))).pop();
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Draft project'), findsOneWidget);
    expect(find.text('Still editing.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final viewport in const {
    'narrow screen': Size(320, 568),
    'short screen': Size(640, 320),
  }.entries) {
    testWidgets('Long confirmation remains usable on a ${viewport.key}', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(viewport.value);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const MaterialApp(home: ProjectFormPage()));

      final description = List.filled(
        25,
        'This project has a long description that should remain readable.',
      ).join(' ');
      for (final entry in {
        'project-name': 'Portfolio project',
        'project-description': description,
        'project-technologies': 'Flutter, Dart, Django',
        'project-link': 'https://example.com/portfolio',
      }.entries) {
        await tester.ensureVisible(find.byKey(ValueKey(entry.key)));
        await tester.enterText(find.byKey(ValueKey(entry.key)), entry.value);
        await tester.pumpAndSettle();
      }
      await tester.ensureVisible(find.text('Save'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
      final link = find.text('Tautan: https://example.com/portfolio');
      await tester.ensureVisible(link);
      await tester.pumpAndSettle();
      expect(tester.getRect(link).bottom, lessThan(viewport.value.height));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Portfolio project'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
