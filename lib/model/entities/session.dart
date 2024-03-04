import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'id_creator.dart';

class Session implements IdCreator {
  late String id;
  List<String> absent;
  List<String> attended;
  List<String> sickLeave;
  String courseName;
  String enrollmentID;
  DateTime expectedStartTime;
  DateTime? startTime;
  DateTime expectedEndTime;
  DateTime? endTime;
  bool state;
  bool concluded = false;
  num? attendance;

  Session({
    this.id = '',
    required this.absent,
    required this.attended,
    required this.sickLeave,
    required this.courseName,
    required this.enrollmentID,
    required this.expectedStartTime,
    this.startTime,
    required this.expectedEndTime,
    this.endTime,
    required this.state,
    required this.concluded,
    this.attendance,
  }) {
    if (id.isEmpty) {
      id = createId();
    }
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      absent: List<String>.from(json['absent']),
      attended: List<String>.from(json['attended']),
      sickLeave: List<String>.from(json['sickLeave']),
      courseName: json['course_name'],
      enrollmentID: json['enrollmentID'],
      expectedStartTime: (json['expectedStartTime'] as Timestamp).toDate(),
      startTime: json['start_time'] != null ? (json['start_time'] as Timestamp).toDate() : null,
      expectedEndTime: (json['expectedEndTime'] as Timestamp).toDate(),
      endTime: json['end_time'] != null ? (json['end_time'] as Timestamp).toDate() : null,
      state: json['state'],
      concluded: json['concluded'],
      attendance: json['attendance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'absent': absent,
      'attended': attended,
      'sickLeave': sickLeave,
      'course_name': courseName,
      'enrollmentID': enrollmentID,
      'expectedStartTime': expectedStartTime,
      'start_time': startTime,
      'expectedEndTime': expectedEndTime,
      'end_time': endTime,
      'state': state,
      'concluded': concluded,
      'attendance': attendance,
    };
  }

  int calculateAttendance() {
    return (attended.length / (attended.length + absent.length + sickLeave.length) * 100).toInt();
  }

  Session copyWith({
    String? id,
    List<String>? absent,
    List<String>? attended,
    List<String>? sickLeave,
    String? courseName,
    String? enrollmentID,
    DateTime? expectedStartTime,
    DateTime? startTime,
    DateTime? expectedEndTime,
    DateTime? endTime,
    bool? state,
    bool? concluded,
    num? attendance,
  }) {
    return Session(
      id: id ?? this.id,
      absent: absent ?? this.absent,
      attended: attended ?? this.attended,
      sickLeave: sickLeave ?? this.sickLeave,
      courseName: courseName ?? this.courseName,
      enrollmentID: enrollmentID ?? this.enrollmentID,
      expectedStartTime: expectedStartTime ?? this.expectedStartTime,
      startTime: startTime ?? this.startTime,
      expectedEndTime: expectedEndTime ?? this.expectedEndTime,
      endTime: endTime ?? this.endTime,
      state: state ?? this.state,
      concluded: concluded ?? this.concluded,
      attendance: attendance ?? this.attendance,
    );
  }

  @override
  String createId() {
    return 'A${Random().nextInt(9999)}';
  }
}

//Sessions Table Fields:
//
// absent : List of student ids
// attended : List of student ids
// sickLeave: List of student ids
// course_name: String (for embedded technical difficulties)
// enrollmentID: Id of the enrollment currently being taught
// hall: The hall in which the course is being taught for this session
// expectedStartTime: DateTime describing when the session is supposed to start
// start_time: The time the teacher has actually started the session
// expectedEndTime: DateTime describing when the session is supposed to end
// end_time: When the doctor decides that attendance period is over
// state: Boolean to check whether the session has started or still scheduled
