class Contact {
  final int id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String email;

  Contact({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
  });

  String get fullName => '$nombre $apellido';

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json['id'] as int,
        nombre: json['nombre'] as String? ?? '',
        apellido: json['apellido'] as String? ?? '',
        telefono: json['telefono'] as String? ?? '',
        email: json['email'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'apellido': apellido,
        'telefono': telefono,
        'email': email,
      };
}
