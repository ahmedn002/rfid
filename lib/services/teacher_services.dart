import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rfid_system/model/entities/enrollment.dart';
import 'package:rfid_system/model/entities/session.dart';
import 'package:rfid_system/model/entities/teacher.dart';
import 'package:rfid_system/model/ui/course_data.dart';
import 'package:rfid_system/model/ui/teacher_dashboard_model.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/services/session_services.dart';

import 'enrollment_services.dart';

class TeacherServices {
  static Future<FirebaseResponseWrapper<List<Teacher>?>> getTeachers() async {
    return await FirebaseFirestore.instance
        .collection(
          'Teachers',
        )
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      final List<Map> teacherJsons = querySnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      final List<Teacher> teachers = teacherJsons.map<Teacher>((Map teacherJson) => Teacher.fromJson(teacherJson as Map<String, dynamic>)).toList();

      return FirebaseResponseWrapper<List<Teacher>?>(
        data: teachers,
        hasError: false,
        message: 'Teachers fetched successfully.',
      );
    });
  }

  static Future<FirebaseResponseWrapper<Teacher?>> login(String username, String password) async {
    QuerySnapshot studentsThatFitCredentials = await FirebaseFirestore.instance
        .collection(
          'Teachers',
        )
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password)
        .get();

    if (studentsThatFitCredentials.docs.isEmpty) {
      return FirebaseResponseWrapper(
        data: null,
        hasError: true,
        message: 'Invalid username or password',
      );
    } else {
      // adding doc id to the json
      Map<String, dynamic> data = studentsThatFitCredentials.docs.first.data() as Map<String, dynamic>;
      data['id'] = studentsThatFitCredentials.docs.first.id;
      return FirebaseResponseWrapper(
        data: Teacher.fromJson(data),
        hasError: false,
        message: 'Login successful',
      );
    }
  }

  static Future<FirebaseResponseWrapper<bool>> addTeacher(Teacher teacher) async {
    bool hasError = false;

    // Get all usernames and compare
    QuerySnapshot usernames = await FirebaseFirestore.instance.collection('Teachers').where('username', isEqualTo: teacher.username).get();
    if (usernames.docs.isNotEmpty) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: true,
        message: 'Username already exists',
      );
    }

    await FirebaseFirestore.instance
        .collection(
          'Teachers',
        )
        .doc(teacher.id)
        .set(teacher.toJson())
        .catchError((error) {
      hasError = true;
    });
    if (hasError) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: hasError,
        message: 'Error adding teacher',
      );
    }
    return FirebaseResponseWrapper(
      data: true,
      hasError: false,
      message: 'Teacher added successfully',
    );
  }

  static Future<FirebaseResponseWrapper<TeacherDashboardModel>> getTeacherDashboardModel(String teacherId) async {
    List<CourseData> teacherCourses = [];

    // Get enrollments taught by teacher
    List<Enrollment> enrollmentsTaughtByTeacher = (await EnrollmentServices.getEnrollmentsTaughtByTeacher(teacherId)).data;

    // Get sessions for each enrollment
    for (Enrollment enrollment in enrollmentsTaughtByTeacher) {
      final List<Session> sessions = (await SessionServices.getSessionsForEnrollment(enrollment.id)).data;
      teacherCourses.add(CourseData(
        courseName: enrollment.courseName,
        courseCode: enrollment.courseCode,
        sessions: sessions,
      ));
    }

    return FirebaseResponseWrapper(
      data: TeacherDashboardModel(
        courses: teacherCourses,
      ),
      hasError: false,
      message: 'Teacher dashboard model fetched successfully',
    );
  }
}
