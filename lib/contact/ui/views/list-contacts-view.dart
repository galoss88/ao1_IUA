import 'package:ao_1/auth/ui/viewModel/login_view_model.dart';
import 'package:ao_1/contact/domain/entities/contact_entity.dart';
import 'package:ao_1/contact/ui/viewModel/contact_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListContactsView extends StatefulWidget {
  const ListContactsView({super.key});

  @override
  State<ListContactsView> createState() => _ListContactsViewState();
}

class _ListContactsViewState extends State<ListContactsView> {
  @override
  void initState() {
    super.initState();
  }

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
              // Mostrar campo de búsqueda
              showSearch(context: context, delegate: ContactSearchDelegate());
            },
          ),
          PopupMenuButton(
            itemBuilder: (_) {
              return [
                const PopupMenuItem(
                  value: "optionLogout",
                  child: Text("Cerrar sesión"),
                ),
              ];
            },
            onSelected: (value) {
              if (value == "optionLogout") {
                loginViewModel.logout();
                // Navigator.pushNamedAndRemoveUntil(context, "/login");
              }
            },
          ),
        ],
      ),
      body: Consumer<ContactViewModel>(
        builder: (context, contactViewModel, child) {
          if (contactViewModel.contacts.isEmpty) {
            return const Center(child: Text('No hay contactos'));
          }

          return ListView.builder(
            itemCount: contactViewModel.contacts.length,
            itemBuilder: (context, index) {
              Contact contact = contactViewModel.contacts[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  child: Icon(Icons.person, color: Colors.white, size: 24),
                ),
                title: Text(
                  contact.fullName,
                  style: const TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                  contact.phone,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.phone, color: Colors.green, size: 24),
                  onPressed: () {
                    // Solo visual
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          // Navegar a pantalla de agregar contacto
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContactView()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class ContactSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
      IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          // Menú de opciones en búsqueda
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<ContactViewModel>(
      builder: (context, contactViewModel, child) {
        List<Contact> results = contactViewModel.contacts.where((contact) {
          return contact.fullName.toLowerCase().contains(query.toLowerCase()) ||
              contact.phone.contains(query);
        }).toList();

        if (results.isEmpty) {
          return const Center(child: Text('No se encontraron contactos'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            Contact contact = results[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                child: Icon(Icons.person, color: Colors.white, size: 24),
              ),
              title: Text(
                contact.fullName,
                style: const TextStyle(fontSize: 16),
              ),
              subtitle: Text(
                contact.phone,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.phone, color: Colors.green, size: 24),
                onPressed: () {
                  // Solo visual, sin funcionalidad extra
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

// Pantalla simple para agregar contactos
class AddContactView extends StatefulWidget {
  const AddContactView({super.key});

  @override
  State<AddContactView> createState() => _AddContactViewState();
}

class _AddContactViewState extends State<AddContactView> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  String selectedGender = 'Femenino';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Validar que todos los campos estén completos
              if (nameController.text.isEmpty ||
                  lastNameController.text.isEmpty ||
                  phoneController.text.isEmpty ||
                  addressController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Complete todos los campos')),
                );
                return;
              }

              // Guardar contacto
              final contact = Contact(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                lastName: lastNameController.text,
                phone: phoneController.text,
                email: '', // No se usa en este formulario
                address: addressController.text,
                birthDate: DateTime.now(),
                gender: selectedGender,
              );

              Provider.of<ContactViewModel>(
                context,
                listen: false,
              ).addContact(contact);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                hintText: 'Ingrese nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Apellido',
                hintText: 'Ingrese apellido',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Número de teléfono',
                hintText: '+54 --- --- ----',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Domicilio',
                hintText: 'Ingrese domicilio',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Sección de Género
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Género',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Radio<String>(
                  value: 'Femenino',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                const Text('Femenino'),
                const SizedBox(width: 20),
                Radio<String>(
                  value: 'Masculino',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                const Text('Masculino'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
