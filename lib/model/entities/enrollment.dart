// Enrollments Table Fields
//
// courseId: ID of the enrollment's course
// days: List of Strings
// hours: double
// sessions: int (number of sessions)
// startDate: DateTime for the first day this enrollment will be taught
// teacherId: teacher who will teach the course for this enrollment
// studentIds: List of student IDs who are enrolled for this enrollment

import 'dart:math';

import 'id_creator.dart';

class Enrollment implements IdCreator {
  late String id;
  final String name;
  final String courseId;
  final String courseName;
  final String courseCode;
  final Map<String, DateTime> days;
  final int hours;
  final int sessions;
  final DateTime startDate;
  final String teacherId;
  final List<String> studentIds;

  Enrollment({
    this.id = '',
    required this.courseId,
    required this.name,
    required this.courseName,
    required this.courseCode,
    required this.days,
    required this.hours,
    required this.sessions,
    required this.startDate,
    required this.teacherId,
    required this.studentIds,
  }) {
    if (id.isEmpty) {
      id = createId();
    }
  }

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    List<String> days = List<String>.from(json['days']); // ['Saturday<>DateTime']
    Map<String, DateTime> daysMap = {for (var day in days) day.split('<>')[0]: DateTime.tryParse(day.split('<>')[1]) ?? DateTime.now()};

    return Enrollment(
      id: json['id'],
      name: json['name'],
      courseId: json['courseID'],
      courseName: json['course_name'],
      courseCode: json['course_code'],
      days: daysMap,
      hours: json['hours'] ?? 0,
      sessions: json['sessions'] ?? 0,
      startDate: DateTime.tryParse(json['startDate']) ?? DateTime.now(),
      teacherId: json['teacherID'],
      studentIds: List<String>.from(json['studentIDs']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'courseID': courseId,
      'course_name': courseName,
      'course_code': courseCode,
      'days': days.entries.map((entry) {
        return '${entry.key}<>${entry.value.toString()}';
      }).toList(),
      'hours': hours,
      'sessions': sessions,
      'startDate': startDate.toString(),
      'teacherID': teacherId,
      'studentIDs': studentIds,
    };
  }

  @override
  String createId() {
    return 'C${Random().nextInt(9999)}';
  }
}
