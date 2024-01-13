import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/screens/student/components/student_navigaition_drawer.dart';
import 'package:rfid_system/ui/screens/student/dashboard/student_dashboard.dart';
import 'package:rfid_system/ui/screens/student/provider/student_navigation_provider.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';

class StudentNavigationWrapper extends StatefulWidget {
  const StudentNavigationWrapper({super.key});

  @override
  State<StudentNavigationWrapper> createState() => _StudentNavigationWrapperState();
}

class _StudentNavigationWrapperState extends State<StudentNavigationWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StudentNavigationProvider>(
      builder: (consumer, studentNavigationProvider, _) => Scaffold(
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
        drawer: const StudentNavigationDrawer(),
        body: IndexedStack(
          index: studentNavigationProvider.currentIndex,
          children: const [
            StudentDashboardScreen(),
          ],
        ),
      ),
    );
  }
}
