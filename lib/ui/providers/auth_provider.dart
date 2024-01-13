import 'package:flutter/material.dart';
import 'package:rfid_system/model/entities/student.dart';
import 'package:rfid_system/model/entities/teacher.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool isSignedIn = false;
  bool isStudent = true;

  late Student student;
  late Teacher teacher;
}
