import 'package:ao_1/contact/data/models/contact_model.dart';
import 'package:ao_1/contact/data/repository/contact_repository.dart';
import 'package:ao_1/contact/domain/entities/contact_entity.dart';
import 'package:ao_1/core/database_config.dart';
import 'package:flutter/material.dart';

class ContactViewModel with ChangeNotifier {
  List<Contact> contacts = [];
  String searchText = '';
  bool isLoading = false;

  ContactViewModel() {
    loadContacts();
  }

  Contact _modelToEntity(ContactModel model) {
    return Contact(
      id: model.id,
      name: model.name,
      lastName: model.lastName,
      phone: model.phone,
      email: model.email,
      address: model.address,
      birthDate: model.birthDate,
      gender: model.gender,
    );
  }

  ContactModel _entityToModel(Contact entity) {
    return ContactModel(
      id: entity.id,
      name: entity.name,
      lastName: entity.lastName,
      phone: entity.phone,
      email: entity.email,
      address: entity.address,
      birthDate: entity.birthDate,
      gender: entity.gender,
    );
  }

  Future<void> loadContacts() async {
    isLoading = true;
    notifyListeners();

    try {
      final database = await DatabaseConfig.database;
      final repository = ContactRepository(database: database);
      final contactModels = await repository.getAllContacts();
      contacts = contactModels.map((model) => _modelToEntity(model)).toList();
    } catch (e) {
      debugPrint("Error al cargar contactos: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addContact(Contact newContact) async {
    try {
      final database = await DatabaseConfig.database;
      final repository = ContactRepository(database: database);
      final contactModel = _entityToModel(newContact);
      final result = await repository.addContact(contactModel);

      if (result != null && result > 0) {
        contacts.add(newContact);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error al agregar contacto: $e");
      return false;
    }
  }

  Future<bool> removeContact(String contactId) async {
    try {
      final contact = contacts.firstWhere((c) => c.id == contactId);
      final database = await DatabaseConfig.database;
      final repository = ContactRepository(database: database);
      final contactModel = _entityToModel(contact);
      final result = await repository.removeContact(contactModel);

      if (result != null && result > 0) {
        contacts.removeWhere((contact) => contact.id == contactId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error al eliminar contacto: $e");
      return false;
    }
  }

  Future<bool> updateContact(Contact updatedContact) async {
    try {
      final database = await DatabaseConfig.database;
      final repository = ContactRepository(database: database);
      final contactModel = _entityToModel(updatedContact);
      final result = await repository.updateContact(contactModel);

      if (result != null && result > 0) {
        final index = contacts.indexWhere((c) => c.id == updatedContact.id);
        if (index != -1) {
          contacts[index] = updatedContact;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint("Error al actualizar contacto: $e");
      return false;
    }
  }

  void setSearchText(String text) {
    searchText = text;
    notifyListeners();
  }

  List<Contact> get filteredContacts {
    if (searchText.isEmpty) {
      return contacts;
    }

    return contacts.where((contact) {
      String fullName = contact.fullName.toLowerCase();
      String phone = contact.phone.toLowerCase();
      String search = searchText.toLowerCase();

      return fullName.contains(search) || phone.contains(search);
    }).toList();
  }
}
