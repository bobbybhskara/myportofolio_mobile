import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  void _replacePage(BuildContext context, Widget page) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.pushReplacement(
      MaterialPageRoute<void>(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(
                    fontSize: 26,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Explore personal projects and experiences!',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            key: const ValueKey('drawer-home'),
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => _replacePage(context, const MyHomePage()),
          ),
          ListTile(
            key: const ValueKey('drawer-add-project'),
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Project'),
            onTap: () => _replacePage(context, const ProjectFormPage()),
          ),
        ],
      ),
    );
  }
}
