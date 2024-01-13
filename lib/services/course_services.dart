import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rfid_system/model/entities/course.dart';
import 'package:rfid_system/services/response_wrapper.dart';

class CourseServices {
  static Future<FirebaseResponseWrapper<List<Course>?>> getCourses() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(
          'Courses',
        )
        .get();

    final List<Map> courseJsons = querySnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();

    final List<Course> courses = courseJsons.map<Course>((Map courseJson) => Course.fromJson(courseJson as Map<String, dynamic>)).toList();

    return FirebaseResponseWrapper<List<Course>?>(
      data: courses,
      hasError: false,
      message: 'Courses fetched successfully.',
    );
  }

  static Future<FirebaseResponseWrapper<bool>> addCourse(Course course) async {
    bool hasError = false;

    await FirebaseFirestore.instance
        .collection(
          'Courses',
        )
        .doc(course.id)
        .set(course.toJson())
        .catchError((error) {
      hasError = true;
    });
    if (hasError) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: hasError,
        message: 'Error adding course',
      );
    }

    return FirebaseResponseWrapper(
      data: true,
      hasError: false,
      message: 'Course added successfully',
    );
  }

  static Future<FirebaseResponseWrapper<bool>> editCourse(Course course) async {
    final FirebaseResponseWrapper<bool> response = await FirebaseFirestore.instance
        .collection(
          'Courses',
        )
        .doc(course.id)
        .update(course.toJson())
        .then(
          (value) => FirebaseResponseWrapper(
            data: true,
            hasError: false,
            message: 'Course edited successfully.',
          ),
        )
        .catchError(
          (error) => FirebaseResponseWrapper(
            data: false,
            hasError: true,
            message: 'Error editing course.',
          ),
        );

    // Need to update all enrollments course_name and course_code
    FirebaseFirestore.instance
        .collection(
          'Enrollments',
        )
        .where('courseID', isEqualTo: course.id)
        .get()
        .then(
      (QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        for (var doc in querySnapshot.docs) {
          FirebaseFirestore.instance
              .collection(
                'Enrollments',
              )
              .doc(doc.id)
              .update(
            {
              'course_name': course.name,
              'course_code': course.code,
            },
          );
        }
      },
    );

    return response;
  }
}
