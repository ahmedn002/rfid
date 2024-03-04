import 'course_data.dart';

class StudentDashboardModel {
  final String studentId;
  final List<CourseData> courseData;
  late final Map<CourseData, int> attendanceWarnings;

  StudentDashboardModel({
    required this.studentId,
    required this.courseData,
  }) {
    attendanceWarnings = {};
    for (int i = 0; i < courseData.length; i++) {
      if (courseData[i].concludedSessionsCount == 0) {
        continue;
      }
      final int attendance = courseData[i].getStudentAttendance(studentId);
      if (attendance <= 50) {
        attendanceWarnings[courseData[i]] = attendance;
      }
    }
  }
}
