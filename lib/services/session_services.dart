import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:rfid_system/model/entities/enrollment.dart';
import 'package:rfid_system/model/entities/session.dart';
import 'package:rfid_system/model/entities/student.dart';
import 'package:rfid_system/model/ui/full_session.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/services/student_services.dart';
import 'package:rfid_system/ui/utilities/date_utilities.dart';

class SessionServices {
  static Future<FirebaseResponseWrapper<bool>> addSession(Session session) async {
    bool hasError = false;

    await FirebaseFirestore.instance
        .collection(
          'Sessions',
        )
        .doc(session.id)
        .set(session.toJson())
        .catchError((error) {
      hasError = true;
    });
    if (hasError) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: hasError,
        message: 'Error adding session',
      );
    }
    return FirebaseResponseWrapper(
      data: true,
      hasError: false,
      message: 'Session added successfully',
    );
  }

  static Future<FirebaseResponseWrapper<bool>> concludeSession(String sessionId) {
    // Set session where this id concluded = true
    return FirebaseFirestore.instance
        .collection(
          'Sessions',
        )
        .doc(sessionId)
        .update({
      'concluded': true,
    }).then((value) {
      return FirebaseResponseWrapper(
        data: true,
        hasError: false,
        message: 'Session concluded successfully',
      );
    }).catchError((error) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: true,
        message: 'Error concluding session',
      );
    });
  }

  static Future<FirebaseResponseWrapper<bool>> rewriteSession(Session session) {
    return FirebaseFirestore.instance
        .collection(
          'Sessions',
        )
        .doc(session.id)
        .update(session.toJson())
        .then((value) {
      return FirebaseResponseWrapper(
        data: true,
        hasError: false,
        message: 'Session concluded successfully',
      );
    }).catchError((error) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: true,
        message: 'Error concluding session',
      );
    });
  }

  static Future<FirebaseResponseWrapper<bool>> addListOfSessions(List<Session> sessions) async {
    bool hasError = false;

    for (var session in sessions) {
      await FirebaseFirestore.instance
          .collection(
            'Sessions',
          )
          .doc(session.id)
          .set(session.toJson())
          .catchError((error) {
        hasError = true;
      });
    }

    if (hasError) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: hasError,
        message: 'Error adding sessions',
      );
    }
    return FirebaseResponseWrapper(
      data: true,
      hasError: false,
      message: 'Sessions added successfully',
    );
  }

  static Future<FirebaseResponseWrapper<List<Session>>> getSessionsForEnrollment(String enrollmentId) async {
    return await FirebaseFirestore.instance
        .collection(
          'Sessions',
        )
        .where('enrollmentID', isEqualTo: enrollmentId)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      final List<Map> sessionJsons = querySnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      final List<Session> sessions = sessionJsons.map<Session>((Map sessionJson) => Session.fromJson(sessionJson as Map<String, dynamic>)).toList();

      return FirebaseResponseWrapper<List<Session>>(
        data: sessions,
        hasError: false,
        message: 'Sessions fetched successfully.',
      );
    });
  }

  static Future<FirebaseResponseWrapper<Session?>> getSession(String sessionId) {
    bool hasError = false;
    return FirebaseFirestore.instance
        .collection(
          'Sessions',
        )
        .doc(sessionId)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> doc) {
      if (doc.exists) {
        return FirebaseResponseWrapper<Session>(
          data: Session.fromJson({
            'id': doc.id,
            ...doc.data()!,
          }),
          hasError: false,
          message: 'Session fetched successfully.',
        );
      } else {
        return FirebaseResponseWrapper<Session?>(
          data: null,
          hasError: true,
          message: 'Session does not exist.',
        );
      }
    }).catchError((error) {
      hasError = true;
    }).then((event) {
      if (hasError) {
        return FirebaseResponseWrapper<Session?>(
          data: null,
          hasError: true,
          message: 'Error fetching session.',
        );
      } else {
        return event;
      }
    });
  }

  static Stream<FirebaseResponseWrapper<Session?>> listenToSession(String sessionId) {
    bool hasError = false;
    return FirebaseFirestore.instance
        .collection(
          'Sessions',
        )
        .doc(sessionId)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> doc) {
      if (doc.exists) {
        return FirebaseResponseWrapper<Session>(
          data: Session.fromJson({
            'id': doc.id,
            ...doc.data()!,
          }),
          hasError: false,
          message: 'Session fetched successfully.',
        );
      } else {
        return FirebaseResponseWrapper<Session?>(
          data: null,
          hasError: true,
          message: 'Session does not exist.',
        );
      }
    }).handleError((error) {
      hasError = true;
    }).map((event) {
      if (hasError) {
        return FirebaseResponseWrapper<Session?>(
          data: null,
          hasError: true,
          message: 'Error fetching session.',
        );
      } else {
        return event;
      }
    });
  }

  static Future<FirebaseResponseWrapper<FullSession?>> getFullSession(String sessionId) async {
    final FirebaseResponseWrapper<Session?> session = await getSession(sessionId);

    if (session.hasError || session.data == null) {
      return FirebaseResponseWrapper<FullSession?>(
        data: null,
        hasError: true,
        message: 'Error fetching session.',
      );
    }

    // Get all students then create the lists
    final FirebaseResponseWrapper<List<Student>> students = await StudentServices.getStudents();

    if (students.hasError) {
      return FirebaseResponseWrapper<FullSession?>(
        data: null,
        hasError: true,
        message: 'Error fetching students.',
      );
    }

    final List<Student> attendanceList = [];
    for (var student in session.data!.attended) {
      try {
        attendanceList.add(students.data.firstWhere((element) => element.id == student));
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    final List<Student> absentList = [];
    for (var student in session.data!.absent) {
      try {
        absentList.add(students.data.firstWhere((element) => element.id == student));
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    final List<Student> sickLeaveList = [];
    for (var student in session.data!.sickLeave) {
      try {
        sickLeaveList.add(students.data.firstWhere((element) => element.id == student));
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    return FirebaseResponseWrapper<FullSession?>(
      data: FullSession(
        sessionDetails: session.data!,
        attendanceList: attendanceList,
        absentList: absentList,
        sickLeaveList: sickLeaveList,
      ),
      hasError: false,
      message: 'Full session fetched successfully.',
    );
  }

  static List<Session> calculateSessionsFromEnrollment(Enrollment enrollment) {
    final List<Session> sessions = [];
    final DateTime startTime = enrollment.startDate;
    DateTime minDate = startTime.subtract(const Duration(days: 1)); // To ensure not getting stuck on the same date
    int sessionCount = enrollment.sessions;

    // Sessions can be multiple days per week such as Saturday and Sunday
    // We need to figure out the dates of each session starting from the start date until session count is reached

    while (sessionCount > 0) {
      // Get the next appropriate day
      minDate = _getNearestAppropriateDay(minDate, enrollment.days);
      sessions.add(Session(
        absent: enrollment.studentIds,
        attended: [],
        sickLeave: [],
        courseName: enrollment.courseId,
        enrollmentID: enrollment.id,
        expectedStartTime: minDate,
        expectedEndTime: minDate.add(Duration(hours: enrollment.hours)),
        state: false,
        concluded: false,
      ));
      sessionCount--;
    }

    for (var element in sessions) {
      debugPrint(DateUtilities.formatDateTime(element.expectedStartTime));
    }

    return sessions;
  }

  static DateTime _getNearestAppropriateDay(DateTime minDate, Map<String, DateTime> days) {
    DateTime result = minDate.add(const Duration(days: 1)); // To ensure not getting stuck on the same date
    List<int> acceptedDayIndices = days.keys.map<int>(_mapDayToIndex).toList();

    while (true) {
      if (acceptedDayIndices.contains(result.weekday)) {
        return _combineDateWithTime(result, days[_mapIndexToDay(result.weekday)]!);
      }

      result = result.add(const Duration(days: 1));
    }
  }

  static int _mapDayToIndex(String day) {
    switch (day) {
      case 'Saturday':
        return 6;
      case 'Sunday':
        return 7;
      case 'Monday':
        return 1;
      case 'Tuesday':
        return 2;
      case 'Wednesday':
        return 3;
      case 'Thursday':
        return 4;
      case 'Friday':
        return 5;
      default:
        return 0;
    }
  }

  static String _mapIndexToDay(int index) {
    switch (index) {
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      default:
        return '';
    }
  }

  static DateTime _combineDateWithTime(DateTime date1, DateTime date2) {
    return DateTime(date1.year, date1.month, date1.day, date2.hour, date2.minute);
  }
}
