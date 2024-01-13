import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rfid_system/model/ui/teacher_dashboard_model.dart';
import 'package:rfid_system/services/teacher_services.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/providers/auth_provider.dart';
import 'package:rfid_system/ui/screens/teacher/dashboard/components/course_card.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_data_provider.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_navigation_provider.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_request_provider.dart';
import 'package:rfid_system/ui/utilities/misc_utilities.dart';
import 'package:rfid_system/ui/widgets/api%20widgets/RequestWidget.dart';
import 'package:rfid_system/ui/widgets/buttons/text_button.dart';

import '../../../../model/entities/session.dart';
import 'components/session_tile.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  late final List<Map<Session, Map>> _teacherSchedule;
  late final Map<String, Color> _courseColors;

  bool _initializedRequest = false;
  bool _initializedTeacherSchedule = false;

  @override
  Widget build(BuildContext context) {
    return Consumer4<AuthenticationProvider, TeacherDataProvider, TeacherRequestProvider, TeacherNavigationProvider>(
      builder: (context, authProvider, teacherDataProvider, teacherRequestProvider, teacherNavigationProvider, _) {
        if (!_initializedRequest) {
          teacherRequestProvider.getTeacherDashboardModel = TeacherServices.getTeacherDashboardModel(authProvider.teacher.id);
          _initializedRequest = true;
        }

        return RequestWidget(
          request: () => teacherRequestProvider.getTeacherDashboardModel,
          successWidgetBuilder: (TeacherDashboardModel model) {
            if (!_initializedTeacherSchedule) {
              teacherDataProvider.setTeacherDashboardModel(model);
              _teacherSchedule = model.getTeacherSchedule();
              _courseColors = {for (var course in model.courses) course.courseCode: MiscUtilities.getRandomMaterialColor()};
              _initializedTeacherSchedule = true;
            }

            return Center(
              child: Column(
                children: [
                  16.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Courses',
                          style: TextStyles.title,
                        ),
                        MainTextButton(
                          text: 'See All',
                          onPressed: () => teacherNavigationProvider.setCurrentIndex(1),
                        )
                      ],
                    ),
                  ),
                  8.verticalSpace,
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          child: CarouselSlider(
                            items: [
                              ...model.courses.map((courseData) => CourseCard(courseData: courseData)).toList(),
                            ],
                            options: CarouselOptions(
                              viewportFraction: 0.8,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  16.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          'Schedule',
                          style: TextStyles.title,
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: ListView.separated(
                        itemCount: _teacherSchedule.length,
                        itemBuilder: (context, index) {
                          return SessionTile(sessionData: _teacherSchedule[index], color: _courseColors[_teacherSchedule[index].values.first['courseCode']]!);
                        },
                        separatorBuilder: (context, index) => 16.verticalSpace,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
