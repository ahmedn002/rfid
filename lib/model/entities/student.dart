import 'dart:math';

import 'package:rfid_system/model/entities/id_creator.dart';

class Student implements IdCreator {
  late String id;
  final String username;
  final String firstName;
  final String lastName;
  final String password;
  final String studentID;
  final int studentLevel;

  Student({
    this.id = '',
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.studentID,
    required this.studentLevel,
  }) {
    if (id.isEmpty) {
      id = createId();
    }
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      password: json['password'],
      studentID: json['student_id'],
      studentLevel: json['student_level'],
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'student_id': studentID,
        'student_level': studentLevel,
      };

  @override
  String createId() {
    return 'D${Random().nextInt(9999)}';
  }
}
