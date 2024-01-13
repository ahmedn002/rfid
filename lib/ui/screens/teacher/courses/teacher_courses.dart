import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rfid_system/model/ui/teacher_dashboard_model.dart';
import 'package:rfid_system/ui/screens/teacher/courses/course_details.dart';
import 'package:rfid_system/ui/screens/teacher/dashboard/components/course_card.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_data_provider.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_request_provider.dart';
import 'package:rfid_system/ui/widgets/api%20widgets/RequestWidget.dart';

class TeacherCourses extends StatelessWidget {
  const TeacherCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<TeacherRequestProvider, TeacherDataProvider>(
      builder: (context, teacherRequestProvider, teacherDataProvider, _) => RequestWidget(
        request: () => teacherRequestProvider.getTeacherDashboardModel,
        successWidgetBuilder: (TeacherDashboardModel model) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.separated(
              itemCount: model.courses.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeacherCourseDetails(courseData: model.courses[index]),
                  ),
                ),
                child: CourseCard(
                  courseData: model.courses[index],
                ),
              ),
              separatorBuilder: (context, index) => 16.verticalSpace,
            ),
          );
        },
      ),
    );
  }
}
