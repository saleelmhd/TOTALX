import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String id;
  final String name;
  final int age;

  Users({required this.id, required this.name, required this.age});

  factory Users.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Users(
      id: snapshot.id,
      name: data['name'],
      age: data['age'],
    );
  }
}
