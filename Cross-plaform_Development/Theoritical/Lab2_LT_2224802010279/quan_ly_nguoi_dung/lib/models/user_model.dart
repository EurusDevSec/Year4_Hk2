import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  // Convert từ Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      age: data['age'] ?? 0,
    );
  }

  // Convert sang Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'age': age};
  }

  // Copy with
  User copyWith({String? id, String? name, String? email, int? age}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
    );
  }

  @override
  String toString() => 'User(id: $id, name: $name, email: $email, age: $age)';
}
