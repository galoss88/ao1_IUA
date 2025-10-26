class Contact {
  final String id;
  final String name;
  final String lastName;
  final String phone;
  final String email;
  final String address;
  final DateTime birthDate;
  final String gender;

  Contact({
    required this.id,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.address,
    required this.birthDate,
    required this.gender,
  });

  String get fullName => '$name $lastName';
  
  String get initials => '${name.isNotEmpty ? name[0].toUpperCase() : ''}${lastName.isNotEmpty ? lastName[0].toUpperCase() : ''}';
}
