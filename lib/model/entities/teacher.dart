import 'dart:math';

import 'package:rfid_system/model/entities/id_creator.dart';

class Teacher implements IdCreator {
  late String id;
  String username;
  String firstName;
  String lastName;
  String password;

  Teacher({
    this.id = '',
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.password,
  }) {
    if (id.isEmpty) {
      id = createId();
    }
  }

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'password': password,
      };

  @override
  String createId() {
    return 'T${Random().nextInt(9999)}';
  }
}
