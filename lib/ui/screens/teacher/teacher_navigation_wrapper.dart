import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/screens/teacher/courses/teacher_courses.dart';
import 'package:rfid_system/ui/screens/teacher/dashboard/teacher_dashboard.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_navigation_provider.dart';
import 'package:rfid_system/ui/screens/teacher/session%20history/session_history_screen.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';

import 'dashboard/components/teacher_navigation_drawer.dart';

class TeacherNavigationWrapper extends StatefulWidget {
  const TeacherNavigationWrapper({super.key});

  @override
  State<TeacherNavigationWrapper> createState() => _TeacherNavigationWrapperState();
}

class _TeacherNavigationWrapperState extends State<TeacherNavigationWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherNavigationProvider>(
      builder: (consumer, teacherNavigationProvider, _) => Scaffold(
        appBar: RFIDAppBar(
          trailing: Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.foregroundTwo,
              child: Icon(
                Icons.person_rounded,
                color: AppColors.textPrimary,
                size: 20.r,
              ),
            ),
          ),
        ),
        drawer: const TeacherNavigationDrawer(),
        body: IndexedStack(
          index: teacherNavigationProvider.currentIndex,
          children: const [
            TeacherDashboard(),
            TeacherCourses(),
            TeacherSessionHistory(),
          ],
        ),
      ),
    );
  }
}
