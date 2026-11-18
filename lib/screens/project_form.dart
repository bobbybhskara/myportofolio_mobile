import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  static const _defaultCategory = 'Web Development';
  static const _categories = [
    _defaultCategory,
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _technologiesController = TextEditingController();
  final _linkController = TextEditingController();
  String _category = _defaultCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _technologiesController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _descriptionController.clear();
    _technologiesController.clear();
    _linkController.clear();
    setState(() => _category = _defaultCategory);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Proyek berhasil ditambahkan!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama Proyek: ${_nameController.text.trim()}'),
              Text('Deskripsi: ${_descriptionController.text.trim()}'),
              Text('Kategori: $_category'),
              Text(
                'Teknologi: ${_technologiesController.text.trim().isEmpty ? '-' : _technologiesController.text.trim()}',
              ),
              Text(
                'Tautan: ${_linkController.text.trim().isEmpty ? '-' : _linkController.text.trim()}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Project Form'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    key: const ValueKey('project-name'),
                    controller: _nameController,
                    decoration: _decoration('Nama Proyek'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Nama proyek tidak boleh kosong!'
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    key: const ValueKey('project-description'),
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: _decoration('Deskripsi Proyek'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Deskripsi proyek tidak boleh kosong!'
                        : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DropdownButtonFormField<String>(
                    key: const ValueKey('project-category'),
                    initialValue: _defaultCategory,
                    isExpanded: true,
                    decoration: _decoration('Kategori Proyek'),
                    items: _categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null && value != _category) {
                        setState(() => _category = value);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    key: const ValueKey('project-technologies'),
                    controller: _technologiesController,
                    decoration: _decoration(
                      'Teknologi yang Digunakan',
                      hint: 'Contoh: Flutter, Django, Figma',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    key: const ValueKey('project-link'),
                    controller: _linkController,
                    keyboardType: TextInputType.url,
                    decoration: _decoration(
                      'Tautan Proyek',
                      hint: 'URL Proyek (opsional)',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
