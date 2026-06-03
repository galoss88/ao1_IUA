import 'package:ao_1/auth/ui/viewModel/login_view_model.dart';
import 'package:ao_1/contact/domain/entities/contact_entity.dart';
import 'package:ao_1/contact/ui/viewModel/contacts_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListContactsView extends StatefulWidget {
  const ListContactsView({super.key});

  @override
  State<ListContactsView> createState() => _ListContactsViewState();
}

class _ListContactsViewState extends State<ListContactsView> {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.read<LoginViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ContactSearchDelegate());
            },
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'optionLogout',
                child: Text('Cerrar sesión'),
              ),
            ],
            onSelected: (value) {
              if (value == 'optionLogout') {
                loginViewModel.logout();
              }
            },
          ),
        ],
      ),
      body: Consumer<ContactViewModel>(
        builder: (context, contactViewModel, child) {
          if (contactViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (contactViewModel.contacts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No hay contactos'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: contactViewModel.loadContacts,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: contactViewModel.contacts.length,
            itemBuilder: (context, index) {
              final contact = contactViewModel.contacts[index];
              return ListTile(
                onTap: () async {
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);

                  final fresh =
                      await contactViewModel.getContactById(contact.id);
                  if (!mounted) return;

                  if (fresh == null) {
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('No se pudo cargar el contacto'),
                      ),
                    );
                    return;
                  }

                  navigator.push(
                    MaterialPageRoute(
                      builder: (_) => EditContactView(contact: fresh),
                    ),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  child: const Icon(Icons.person, color: Colors.white, size: 24),
                ),
                title: Text(contact.fullName),
                subtitle: Text(
                  contact.telefono,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.phone, color: Colors.green),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () =>
                          _confirmDelete(context, contactViewModel, contact),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddContactView()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ContactViewModel vm,
    Contact contact,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar contacto'),
        content: Text('¿Seguro que querés eliminar a ${contact.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final ok = await vm.removeContact(contact.id);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          ok ? 'Contacto eliminado' : 'Error al eliminar el contacto',
        ),
      ),
    );
  }
}

class ContactSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    return Consumer<ContactViewModel>(
      builder: (context, vm, _) {
        final results = vm.contacts.where((c) {
          return c.fullName.toLowerCase().contains(query.toLowerCase()) ||
              c.telefono.contains(query);
        }).toList();

        if (results.isEmpty) {
          return const Center(child: Text('No se encontraron contactos'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final contact = results[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                child: const Icon(Icons.person, color: Colors.white, size: 24),
              ),
              title: Text(contact.fullName),
              subtitle: Text(contact.telefono),
            );
          },
        );
      },
    );
  }
}

class AddContactView extends StatefulWidget {
  const AddContactView({super.key});

  @override
  State<AddContactView> createState() => _AddContactViewState();
}

class _AddContactViewState extends State<AddContactView> {
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final telefonoController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar contacto'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _submit(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: apellidoController,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: telefonoController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (nombreController.text.isEmpty ||
        apellidoController.text.isEmpty ||
        telefonoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete los campos obligatorios')),
      );
      return;
    }

    final contact = Contact(
      id: 0,
      nombre: nombreController.text.trim(),
      apellido: apellidoController.text.trim(),
      telefono: telefonoController.text.trim(),
      email: emailController.text.trim(),
    );

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final vm = Provider.of<ContactViewModel>(context, listen: false);

    final success = await vm.addContact(contact);
    if (!mounted) return;

    if (success) {
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Contacto agregado exitosamente')),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('Error al agregar contacto')),
      );
    }
  }
}

class EditContactView extends StatefulWidget {
  final Contact contact;

  const EditContactView({super.key, required this.contact});

  @override
  State<EditContactView> createState() => _EditContactViewState();
}

class _EditContactViewState extends State<EditContactView> {
  late final TextEditingController nombreController;
  late final TextEditingController apellidoController;
  late final TextEditingController telefonoController;
  late final TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.contact.nombre);
    apellidoController = TextEditingController(text: widget.contact.apellido);
    telefonoController = TextEditingController(text: widget.contact.telefono);
    emailController = TextEditingController(text: widget.contact.email);
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar contacto'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _submit(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: apellidoController,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: telefonoController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (nombreController.text.isEmpty ||
        apellidoController.text.isEmpty ||
        telefonoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete los campos obligatorios')),
      );
      return;
    }

    final updated = Contact(
      id: widget.contact.id,
      nombre: nombreController.text.trim(),
      apellido: apellidoController.text.trim(),
      telefono: telefonoController.text.trim(),
      email: emailController.text.trim(),
    );

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final vm = Provider.of<ContactViewModel>(context, listen: false);

    final success = await vm.updateContact(updated);
    if (!mounted) return;

    if (success) {
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Contacto actualizado exitosamente')),
      );
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('Error al actualizar contacto')),
      );
    }
  }
}
