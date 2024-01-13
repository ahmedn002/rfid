import '../entities/session.dart';

class CourseData {
  final String courseName;
  final String courseCode;
  late final int concludedSessionsCount;
  late final List<Session> scheduledSessions;
  late final List<Session> concludedSessions;
  late final int totalSessions;
  late final DateTime? nextSession;
  late final double attendance;
  final List<Session> sessions;

  CourseData({
    required this.courseName,
    required this.courseCode,
    required this.sessions,
  }) {
    _findConcludedSessions();
    _findTotalSessions();
    _findScheduledSessions();
    _findNextSession();
    _calculateAttendance();
    sessions.sort((Session a, Session b) => a.expectedStartTime.compareTo(b.expectedStartTime));
  }

  void _findConcludedSessions() {
    concludedSessions = sessions.where((session) => session.endTime != null || session.concluded).toList();
    concludedSessionsCount = concludedSessions.length;
  }

  void _findTotalSessions() {
    totalSessions = sessions.length;
  }

  void _findScheduledSessions() {
    scheduledSessions = sessions.where((session) => session.startTime == null).toList();
  }

  void _findNextSession() {
    if (scheduledSessions.isEmpty) {
      nextSession = null;
      return;
    }

    // find in scheduledSessions the session with the earliest expectedStartTime
    nextSession = scheduledSessions.reduce((value, element) {
      if (value.expectedStartTime.isBefore(element.expectedStartTime)) {
        return value;
      } else {
        return element;
      }
    }).expectedStartTime;
  }

  List<Session> getSortedSessions() {
    List<Session> sortedSessions = sessions;
    sortedSessions.sort((Session a, Session b) => a.expectedStartTime.compareTo(b.expectedStartTime));
    return sortedSessions;
  }

  void _calculateAttendance() {
    // Use session.attendance to calculate attendance
    double totalAttendance = 0;
    for (var session in concludedSessions) {
      totalAttendance += session.calculateAttendance();
    }

    attendance = totalAttendance / concludedSessionsCount;
  }

  int getSessionIndex(Session session) {
    int index = 0;
    for (Session s in sessions) {
      if (s.id == session.id) {
        return index;
      }
      index++;
    }
    return -1;
  }

  int getStudentAttendance(String studentId) {
    double totalAttendance = 0;
    for (var session in concludedSessions) {
      if (session.attended.contains(studentId)) {
        totalAttendance++;
      }
    }

    return ((totalAttendance / concludedSessionsCount) * 100).ceil();
  }
}
