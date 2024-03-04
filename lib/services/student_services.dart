import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rfid_system/model/entities/enrollment.dart';
import 'package:rfid_system/model/entities/session.dart';
import 'package:rfid_system/model/entities/student.dart';
import 'package:rfid_system/model/ui/course_data.dart';
import 'package:rfid_system/model/ui/student_dashboard_model.dart';
import 'package:rfid_system/services/enrollment_services.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/services/session_services.dart';

class StudentServices {
  static Future<FirebaseResponseWrapper<List<Student>>> getStudents() async {
    return await FirebaseFirestore.instance
        .collection(
          'Students',
        )
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      final List<Map> studentJsons = querySnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      final List<Student> students = studentJsons.map<Student>((Map studentJson) => Student.fromJson(studentJson as Map<String, dynamic>)).toList();

      return FirebaseResponseWrapper<List<Student>>(
        data: students,
        hasError: false,
        message: 'Students fetched successfully.',
      );
    });
  }

  static Future<FirebaseResponseWrapper<Student?>> login(String username, String password) async {
    QuerySnapshot studentsThatFitCredentials = await FirebaseFirestore.instance
        .collection(
          'Students',
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
        data: Student.fromJson(data),
        hasError: false,
        message: 'Login successful',
      );
    }
  }

  static Future<FirebaseResponseWrapper<bool>> addStudent(Student student) async {
    bool hasError = false;

    // Get all usernames and compare
    QuerySnapshot usernames = await FirebaseFirestore.instance
        .collection(
          'Students',
        )
        .where('username', isEqualTo: student.username)
        .get();

    if (usernames.docs.isNotEmpty) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: true,
        message: 'Username already exists',
      );
    }

    await FirebaseFirestore.instance
        .collection(
          'Students',
        )
        .doc(student.id)
        .set(student.toJson())
        .catchError((error) {
      hasError = true;
    });

    if (hasError) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: hasError,
        message: 'Error adding student',
      );
    }
    return FirebaseResponseWrapper(
      data: true,
      hasError: false,
      message: 'Student added successfully',
    );
  }

  static Future<FirebaseResponseWrapper<StudentDashboardModel?>> getStudentDashboardModel(Student student) async {
    // Get student's enrollments
    final FirebaseResponseWrapper<List<Enrollment>> enrollments = await EnrollmentServices.getStudentEnrollments(student.id);

    if (enrollments.hasError) {
      return FirebaseResponseWrapper(
        data: null,
        hasError: true,
        message: 'Error fetching student\'s enrollments',
      );
    }

    final List<CourseData> studentCourses = [];
    // Get student's sessions for each enrollment
    for (int i = 0; i < enrollments.data.length; i++) {
      final FirebaseResponseWrapper<List<Session>> sessions = await SessionServices.getSessionsForEnrollment(enrollments.data[i].id);
      if (sessions.hasError) {
        return FirebaseResponseWrapper(
          data: null,
          hasError: true,
          message: 'Error fetching student\'s sessions',
        );
      }
      studentCourses.add(CourseData(
        courseName: enrollments.data[i].courseName,
        courseCode: enrollments.data[i].courseCode,
        sessions: sessions.data,
      ));
    }

    return FirebaseResponseWrapper(
      data: StudentDashboardModel(
        studentId: student.id,
        courseData: studentCourses,
      ),
      hasError: false,
      message: 'Student dashboard model fetched successfully',
    );
  }
}
