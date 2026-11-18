import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

void main() {
  testWidgets('Add Project card pushes a form and can return to Home', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final home = tester.element(find.byType(MyHomePage));
    final navigator = Navigator.of(home);

    await tester.ensureVisible(find.text('Tambah Proyek'));
    await tester.tap(find.text('Tambah Proyek'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(navigator.canPop(), isTrue);
    expect(
      find.text('Kamu telah menekan tombol Tambah Proyek!'),
      findsOneWidget,
    );
    navigator.pop();
    await tester.pumpAndSettle();

    expect(find.byType(ProjectFormPage), findsNothing);
    expect(tester.element(find.byType(MyHomePage)), same(home));
    expect(navigator.canPop(), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Shared drawer replaces routes for Home and Add Project', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.text('My Portfolio'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('drawer-add-project')));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectFormPage), findsOneWidget);
    expect(navigator.canPop(), isFalse);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('drawer-home')));
    await tester.pumpAndSettle();

    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(ProjectFormPage), findsNothing);
    expect(navigator.canPop(), isFalse);
    expect(tester.takeException(), isNull);
  });
}
