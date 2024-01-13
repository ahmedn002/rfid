import 'package:rfid_system/model/entities/session.dart';
import 'package:rfid_system/model/entities/student.dart';
import 'package:rfid_system/ui/constants/lookups.dart';

class FullSession {
  final Session sessionDetails;
  List<Student> attendanceList;
  List<Student> absentList;
  List<Student> sickLeaveList;

  FullSession({
    required this.sessionDetails,
    required this.attendanceList,
    required this.absentList,
    required this.sickLeaveList,
  });

  Map<Student, String> getAttendanceMap() {
    Map<Student, String> attendanceListMap = {};
    for (var student in attendanceList) {
      attendanceListMap[student] = Lookups.attended;
    }
    for (var student in absentList) {
      attendanceListMap[student] = Lookups.absent;
    }
    for (var student in sickLeaveList) {
      attendanceListMap[student] = Lookups.sickLeave;
    }
    return attendanceListMap;
  }

  int getAttendanceCount() {
    return attendanceList.length + absentList.length + sickLeaveList.length;
  }
}
