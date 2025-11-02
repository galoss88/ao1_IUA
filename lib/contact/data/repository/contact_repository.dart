import 'package:ao_1/contact/data/models/contact_model.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class ContactRepository {
  final Database _database;
  ContactRepository({required Database database}) : _database = database;

  Future<int?> addContact(ContactModel contact) async {
    try {
      final contactInserToDb = contact.toMap();
      final contactInsert = await _database.insert(
        "contacts",
        contactInserToDb,
      );
      return contactInsert;
    } catch (e) {
      debugPrint("Falló la insercion de un contacto. ${e.toString()}");
      return null;
    }
  }

  Future<int?> removeContact(ContactModel contact) async {
    try {
      final numberRawDelete = await _database.delete(
        "contacts",
        where: "id = ?",
        whereArgs: [contact.id],
      );
      return numberRawDelete;
    } catch (e) {
      debugPrint("Falló la eliminacion de un contacto. ${e.toString()}");
      return null;
    }
  }

  Future<int?> updateContact(ContactModel contact) async {
    try {
      final contactMap = contact.toMap();
      final numberRawUpdate = await _database.update(
        "contacts",
        contactMap,
        where: "id = ?",
        whereArgs: [contact.id],
      );
      return numberRawUpdate;
    } catch (e) {
      debugPrint("Falló la actualización de un contacto. ${e.toString()}");
      return null;
    }
  }

  Future<List<ContactModel>> getAllContacts() async {
    try {
      final List<Map<String, dynamic>> maps = await _database.query("contacts");
      return List.generate(maps.length, (i) {
        return ContactModel(
          id: maps[i]['id'] as String,
          name: maps[i]['name'] as String,
          lastName: maps[i]['lastName'] as String,
          phone: maps[i]['phone'] as String,
          email: maps[i]['email'] as String? ?? '',
          address: maps[i]['address'] as String,
          birthDate: DateTime.parse(maps[i]['birthDate'] as String),
          gender: maps[i]['gender'] as String,
        );
      });
    } catch (e) {
      debugPrint("Falló la obtención de contactos. ${e.toString()}");
      return [];
    }
  }
}
