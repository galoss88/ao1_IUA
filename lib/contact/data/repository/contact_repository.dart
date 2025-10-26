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

  
}
