import 'dart:math';

import 'package:rfid_system/model/entities/id_creator.dart';

class Course implements IdCreator {
  String id;
  final String name;
  final String code;
  final int level;

  Course({
    this.id = '',
    required this.name,
    required this.code,
    required this.level,
  }) {
    if (id.isEmpty) {
      id = createId();
    }
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      level: json['level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'level': level,
    };
  }

  @override
  String createId() {
    return 'B${Random().nextInt(9999)}';
  }
}
