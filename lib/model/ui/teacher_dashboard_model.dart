import 'package:rfid_system/model/ui/course_data.dart';

import '../entities/session.dart';

class TeacherDashboardModel {
  final List<CourseData> courses;

  TeacherDashboardModel({
    required this.courses,
  });

  List<Map<Session, Map>> getTeacherSchedule() {
    // Each course data has a list of sessions
    // Sort all sessions by date from earliest to latest

    // Each session should have an index of which session it is in the list of session of its course
    // Each session should also include the course code and course name

    List<Map<Session, Map>> unsortedSessions = [];

    for (CourseData course in courses) {
      final List<Session> courseSessions = course.scheduledSessions;
      courseSessions.sort((Session a, Session b) => a.expectedStartTime.compareTo(b.expectedStartTime));
      for (Session session in courseSessions) {
        unsortedSessions.add({
          session: {
            'courseCode': course.courseCode,
            'courseName': course.courseName,
            'sessionIndex': courseSessions.indexOf(session),
          }
        });
      }
    }

    unsortedSessions.sort((Map<Session, Map> a, Map<Session, Map> b) => a.keys.first.expectedStartTime.compareTo(b.keys.first.expectedStartTime));
    final List<Map<Session, Map>> sortedSessions = unsortedSessions;
    return sortedSessions;
  }

  CourseData? getCourseDataFromSession(Session session) {
    for (CourseData course in courses) {
      if (course.sessions.any((courseSession) => courseSession.id == session.id)) {
        return course;
      }
    }
    return null;
  }

  List<Session> getSessionHistory() {
    List<Session> sessionHistory = [];
    for (CourseData course in courses) {
      sessionHistory.addAll(course.concludedSessions);
    }
    sessionHistory.sort((Session a, Session b) => a.expectedStartTime.compareTo(b.expectedStartTime));
    return sessionHistory;
  }
}
