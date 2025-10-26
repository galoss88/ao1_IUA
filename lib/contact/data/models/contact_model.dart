class ContactModel {
  final String id;
  final String name;
  final String lastName;
  final String phone;
  final String email;
  final String address;
  final DateTime birthDate;
  final String gender;

  ContactModel({
    required this.id,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.address,
    required this.birthDate,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "lastName": lastName,
      "phone": phone,
      "email": email,
      "address": address,
      "birthDate": birthDate,
      "gender": gender,
    };
  }
}
