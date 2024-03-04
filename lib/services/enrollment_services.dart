import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rfid_system/model/entities/session.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/services/session_services.dart';

import '../model/entities/enrollment.dart';

class EnrollmentServices {
  static Future<FirebaseResponseWrapper<bool>> addEnrollment(Enrollment enrollment) async {
    bool hasError = false;

    await FirebaseFirestore.instance
        .collection(
          'Enrollments',
        )
        .doc(enrollment.id)
        .set(enrollment.toJson())
        .catchError((error) {
      hasError = true;
    });
    if (hasError) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: hasError,
        message: 'Error adding enrollment',
      );
    }

    List<Session> sessions = await SessionServices.calculateSessionsFromEnrollment(enrollment);
    final FirebaseResponseWrapper<bool> response = await SessionServices.addListOfSessions(sessions);
    if (response.hasError) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: response.hasError,
        message: 'Error adding sessions for enrollment, please check and add them manually',
      );
    }

    return FirebaseResponseWrapper(
      data: true,
      hasError: false,
      message: 'Enrollment added successfully',
    );
  }

  static Future<FirebaseResponseWrapper<List<Enrollment>>> getEnrollments() async {
    return await FirebaseFirestore.instance
        .collection(
          'Enrollments',
        )
        .get()
        .then(
      (QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        final List<Map> enrollmentJsons = querySnapshot.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return {
              'id': doc.id,
              ...doc.data(),
            };
          },
        ).toList();

        final List<Enrollment> enrollments = enrollmentJsons.map<Enrollment>((Map enrollmentJson) => Enrollment.fromJson(enrollmentJson as Map<String, dynamic>)).toList();

        return FirebaseResponseWrapper<List<Enrollment>>(
          data: enrollments,
          hasError: false,
          message: 'Enrollments fetched successfully.',
        );
      },
    );
  }

  static Future<FirebaseResponseWrapper<List<Enrollment>>> getEnrollmentsTaughtByTeacher(String teacherId) async {
    return await FirebaseFirestore.instance
        .collection(
          'Enrollments',
        )
        .where('teacherID', isEqualTo: teacherId)
        .get()
        .then(
      (QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        final List<Map> enrollmentJsons = querySnapshot.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return {
              'id': doc.id,
              ...doc.data(),
            };
          },
        ).toList();

        final List<Enrollment> enrollments = enrollmentJsons.map<Enrollment>((Map enrollmentJson) => Enrollment.fromJson(enrollmentJson as Map<String, dynamic>)).toList();

        return FirebaseResponseWrapper<List<Enrollment>>(
          data: enrollments,
          hasError: false,
          message: 'Enrollments fetched successfully.',
        );
      },
    );
  }

  static Future<FirebaseResponseWrapper<List<Enrollment>>> getStudentEnrollments(String studentId) {
    return FirebaseFirestore.instance
        .collection(
          'Enrollments',
        )
        .where('studentIDs', arrayContains: studentId)
        .get()
        .then(
      (QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        final List<Map> enrollmentJsons = querySnapshot.docs.map(
          (QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return {
              'id': doc.id,
              ...doc.data(),
            };
          },
        ).toList();

        final List<Enrollment> enrollments = enrollmentJsons.map<Enrollment>((Map enrollmentJson) => Enrollment.fromJson(enrollmentJson as Map<String, dynamic>)).toList();

        return FirebaseResponseWrapper<List<Enrollment>>(
          data: enrollments,
          hasError: false,
          message: 'Enrollments fetched successfully.',
        );
      },
    );
  }

  static Future<FirebaseResponseWrapper<bool>> editEnrollment(Enrollment enrollment) async {
    // Step 1: Delete all sessions associated with this enrollment (THAT ARE NOT CONCLUDED)
    final FirebaseResponseWrapper<List<Session>> response = await SessionServices.getSessionsForEnrollment(enrollment.id);

    if (response.hasError) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: response.hasError,
        message: 'Error fetching sessions for enrollment, please check and edit them manually',
      );
    }

    final List<Session> sessions = response.data;

    final int concludedSessionCount = sessions.where((Session session) => session.concluded).length;

    for (Session session in sessions) {
      if (!session.concluded) {
        FirebaseFirestore.instance
            .collection(
              'Sessions',
            )
            .doc(session.id)
            .delete();
      }
    }

    // Step 2: Add new sessions for this enrollment
    final List<Session> newSessions = await SessionServices.calculateSessionsFromEnrollment(enrollment);

    // Skipping the first concluded sessions
    final List<Session> newSessionsUnconcluded = newSessions.skip(concludedSessionCount).toList();

    final FirebaseResponseWrapper<bool> addSessionsResponse = await SessionServices.addListOfSessions(newSessions);

    if (addSessionsResponse.hasError) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: addSessionsResponse.hasError,
        message: 'Error adding sessions for enrollment, please check and edit them manually',
      );
    }

    // Step 3: Update enrollment

    final FirebaseResponseWrapper<bool> updateEnrollmentResponse = await FirebaseFirestore.instance
        .collection(
          'Enrollments',
        )
        .doc(enrollment.id)
        .update(enrollment.toJson())
        .then(
          (value) => FirebaseResponseWrapper(
            data: true,
            hasError: false,
            message: 'Enrollment edited successfully.',
          ),
        )
        .catchError(
          (error) => FirebaseResponseWrapper(
            data: false,
            hasError: true,
            message: 'Error editing enrollment, please check and edit it manually',
          ),
        );

    return updateEnrollmentResponse;
  }
}
