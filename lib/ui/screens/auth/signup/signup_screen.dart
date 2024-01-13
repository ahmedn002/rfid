import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/model/entities/student.dart';
import 'package:rfid_system/services/student_services.dart';
import 'package:rfid_system/services/teacher_services.dart';
import 'package:rfid_system/tools/send_data_service_handler.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/screens/auth/components/input_field.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';
import 'package:rfid_system/ui/widgets/buttons/main_button.dart';
import 'package:rfid_system/ui/widgets/buttons/select_button.dart';

import '../../../../model/entities/teacher.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isStudent = true;

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _studentLevelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar('Sign Up'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              20.verticalSpace,
              Row(children: [Text('Select role:', style: TextStyles.title)]),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SelectButton(
                    text: 'Student',
                    isSelected: isStudent,
                    onTap: () {
                      setState(() {
                        isStudent = true;
                      });
                    },
                  ),
                  SelectButton(
                    text: 'Teacher',
                    isSelected: !isStudent,
                    onTap: () {
                      setState(() {
                        isStudent = false;
                      });
                    },
                  ),
                ],
              ),
              20.verticalSpace,
              Row(children: [Text('Enter data:', style: TextStyles.title)]),
              10.verticalSpace,
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputField(
                      controller: _usernameController,
                      hintText: 'Username',
                      icon: Icons.person_rounded,
                      validator: (value) => _validateString(value, 'Username is required'),
                    ),
                    20.verticalSpace,
                    InputField(
                      controller: _firstNameController,
                      hintText: 'First Name',
                      icon: Icons.edit_rounded,
                      validator: (value) => _validateString(value, 'First Name is required'),
                    ),
                    20.verticalSpace,
                    InputField(
                      controller: _lastNameController,
                      hintText: 'Last Name',
                      icon: Icons.edit_rounded,
                      validator: (value) => _validateString(value, 'Last Name is required'),
                    ),
                    20.verticalSpace,
                    InputField(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      icon: Icons.lock_rounded,
                      validator: (value) => _validateString(value, 'Password is required'),
                    ),
                    20.verticalSpace,
                    InputField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirm Password',
                      obscureText: true,
                      icon: Icons.lock_rounded,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm Password is required';
                        }
                        if (value != _passwordController.text) {
                          return 'Confirm Password does not match';
                        }
                        return null;
                      },
                    ),
                    20.verticalSpace,
                    if (isStudent) ...[
                      InputField(
                        controller: _studentLevelController,
                        hintText: 'Student Level',
                        icon: Icons.school_rounded,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Student Level is required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Student Level must be a number';
                          } else if (int.parse(value) < 1 || int.parse(value) > 12) {
                            return 'Student Level must be between 1 and 12';
                          }
                          return null;
                        },
                      ),
                      20.verticalSpace,
                    ],
                    MainButton(
                      text: 'Add',
                      onPressed: _signUp,
                      icon: const Icon(Icons.person_add_rounded),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateString(String? value, String message) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      final String id;
      if (isStudent) {
        RequestHandler.handleRequest(
          context: context,
          service: () => StudentServices.addStudent(
            Student(
              username: _usernameController.text,
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              password: _passwordController.text,
              studentID: (1000000 + Random().nextInt(8999999)).toString(), // 7 integer random
              studentLevel: int.parse(_studentLevelController.text),
            ),
          ),
        );
      } else {
        RequestHandler.handleRequest(
          context: context,
          service: () => TeacherServices.addTeacher(
            Teacher(
              username: _usernameController.text,
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              password: _passwordController.text,
            ),
          ),
        );
      }
    }
  }
}
