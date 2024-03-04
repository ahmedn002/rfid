import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rfid_system/model/ui/course_data.dart';
import 'package:rfid_system/model/ui/student_dashboard_model.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/services/student_services.dart';
import 'package:rfid_system/ui/providers/auth_provider.dart';
import 'package:rfid_system/ui/screens/teacher/dashboard/components/course_card.dart';
import 'package:rfid_system/ui/widgets/api%20widgets/RequestWidget.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  late final Future<FirebaseResponseWrapper<StudentDashboardModel?>> _dashboardRequest;

  @override
  void initState() {
    _dashboardRequest = StudentServices.getStudentDashboardModel(
      Provider.of<AuthenticationProvider>(context, listen: false).student,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: RequestWidget<StudentDashboardModel?>(
        request: () => _dashboardRequest,
        successWidgetBuilder: (StudentDashboardModel? model) {
          final List<CourseData> courses = model!.courseData;
          final Map<CourseData, int> attendanceWarnings = model.attendanceWarnings;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              if (model.attendanceWarnings.isNotEmpty) ...[
                Text('Attendance Warnings', style: TextStyles.title),
                8.verticalSpace,
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: attendanceWarnings.length,
                  itemBuilder: (context, index) {
                    final CourseData course = attendanceWarnings.keys.elementAt(index);
                    final int attendance = attendanceWarnings[course]!;
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.fail.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: ListTile(
                        title: Text(
                          '${course.courseCode} - ${course.courseName}',
                          style: TextStyles.body.apply(fontWeightDelta: 2),
                        ),
                        subtitle: Text(
                          'You have $attendance% attendance in this course',
                          style: TextStyles.body.apply(
                            color: AppColors.textPrimary,
                            fontWeightDelta: 1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
              16.verticalSpace,
              Text('Courses', style: TextStyles.title),
              8.verticalSpace,
              Expanded(
                child: ListView.separated(
                  itemCount: courses.length,
                  itemBuilder: (context, index) => CourseCard(
                    courseData: courses[index],
                    isStudent: true,
                  ),
                  separatorBuilder: (context, index) => 8.verticalSpace,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
