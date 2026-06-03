import 'package:ao_1/contact/domain/entities/contact_entity.dart';
import 'package:ao_1/core/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ContactRepository {
  final Dio _dio = DioClient.instance;

  Future<List<Contact>> getAllContacts() async {
    try {
      final response = await _dio.get('/minimal/contactos');
      final List data = response.data as List;
      return data.map((e) => Contact.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      debugPrint('getAllContacts error: ${e.message}');
      return [];
    }
  }

  Future<Contact?> getContactById(int id) async {
    try {
      final response = await _dio.get('/api/contacto/$id');
      return Contact.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('getContactById error: ${e.message}');
      return null;
    }
  }

  Future<Contact?> addContact(Contact contact) async {
    try {
      final response = await _dio.post('/api/contacto/add', data: contact.toJson());
      return Contact.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('addContact error: ${e.message}');
      return null;
    }
  }

  Future<bool> updateContact(int id, Contact contact) async {
    try {
      await _dio.put('/api/contacto/edit/$id', data: contact.toJson());
      return true;
    } on DioException catch (e) {
      debugPrint('updateContact error: ${e.message}');
      return false;
    }
  }

  Future<bool> deleteContact(int id) async {
    try {
      await _dio.delete('/api/contacto/delete/$id');
      return true;
    } on DioException catch (e) {
      debugPrint('deleteContact error: ${e.message}');
      return false;
    }
  }
}
