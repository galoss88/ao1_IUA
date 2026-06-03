import 'package:ao_1/contact/data/repository/contact_repository.dart';
import 'package:ao_1/contact/domain/entities/contact_entity.dart';
import 'package:flutter/material.dart';

class ContactViewModel with ChangeNotifier {
  final ContactRepository _repository = ContactRepository();

  List<Contact> contacts = [];
  bool isLoading = false;
  String errorMessage = '';

  ContactViewModel() {
    loadContacts();
  }

  Future<void> loadContacts() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      contacts = await _repository.getAllContacts();
    } catch (e) {
      errorMessage = 'Error al cargar contactos';
      debugPrint('loadContacts error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addContact(Contact contact) async {
    try {
      final created = await _repository.addContact(contact);
      if (created != null) {
        contacts.add(created);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('addContact error: $e');
      return false;
    }
  }

  Future<bool> updateContact(Contact contact) async {
    try {
      final success = await _repository.updateContact(contact.id, contact);
      if (success) {
        final index = contacts.indexWhere((c) => c.id == contact.id);
        if (index != -1) {
          contacts[index] = contact;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('updateContact error: $e');
      return false;
    }
  }

  Future<bool> removeContact(int contactId) async {
    contacts.removeWhere((c) => c.id == contactId);
    notifyListeners();
    return true;
  }
}
