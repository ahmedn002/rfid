import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/model/entities/course.dart';
import 'package:rfid_system/services/course_services.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/widgets/api%20widgets/RequestWidget.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';

import 'create_course.dart';

class ManageCoursesScreen extends StatefulWidget {
  const ManageCoursesScreen({super.key});

  @override
  State<ManageCoursesScreen> createState() => _ManageCoursesScreenState();
}

class _ManageCoursesScreenState extends State<ManageCoursesScreen> {
  Future<FirebaseResponseWrapper<List<Course>?>> _coursesRequest = CourseServices.getCourses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar('Manage Courses'),
      body: RequestWidget(
        request: () => _coursesRequest,
        successWidgetBuilder: (List<Course>? courses) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.separated(
              itemCount: courses!.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: AppColors.foregroundOne,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.accent,
                      child: Text(
                        courses[index].level.toString(),
                        style: TextStyles.body.apply(color: AppColors.background),
                      ),
                    ),
                    title: Text(courses[index].name),
                    subtitle: Text(courses[index].code),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CreateCourseScreen(
                            edit: true,
                            course: courses[index],
                            onCourseEdit: () {
                              setState(() {
                                _coursesRequest = CourseServices.getCourses();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => 16.verticalSpace,
            ),
          );
        },
      ),
    );
  }
}
