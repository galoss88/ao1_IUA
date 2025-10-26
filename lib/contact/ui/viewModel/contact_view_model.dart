import 'package:ao_1/contact/domain/entities/contact_entity.dart';
import 'package:flutter/material.dart';

class ContactViewModel with ChangeNotifier {
  List<Contact> contacts = [];
  String searchText = '';

  void addContact(Contact newContact) {
    contacts.add(newContact);
    notifyListeners();
  }

  void removeContact(String contactId) {
    contacts.removeWhere((contact) => contact.id == contactId);
    notifyListeners();
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
