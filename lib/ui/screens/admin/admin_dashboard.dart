import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/providers/auth_provider.dart';
import 'package:rfid_system/ui/screens/admin/screens/create_course.dart';
import 'package:rfid_system/ui/screens/admin/screens/create_enrollment.dart';
import 'package:rfid_system/ui/screens/admin/screens/manage%20courses.dart';
import 'package:rfid_system/ui/screens/admin/screens/manage_enrollments.dart';
import 'package:rfid_system/ui/screens/admin/screens/password_reset_requests.dart';
import 'package:rfid_system/ui/screens/auth/signin/signin_screen.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';
import 'package:rfid_system/ui/widgets/buttons/main_button.dart';

import '../auth/signup/signup_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, _) => Scaffold(
        appBar: RFIDAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Text('Logged in as Admin.', style: TextStyles.title),
              20.verticalSpace,
              Text('Tools:', style: TextStyles.title),
              10.verticalSpace,
              MainButton(
                text: 'Add student or teacher',
                icon: const Icon(Icons.person_add_rounded),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
              ),
              10.verticalSpace,
              MainButton(
                text: 'Create Course',
                icon: const Icon(Icons.add_rounded),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateCourseScreen(),
                    ),
                  );
                },
              ),
              10.verticalSpace,
              MainButton(
                text: 'Manage Courses',
                icon: const Icon(Icons.edit_rounded),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ManageCoursesScreen(),
                  ),
                ),
              ),
              10.verticalSpace,
              MainButton(
                text: 'Create Class',
                icon: const Icon(Icons.add_rounded),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateEnrollmentScreen(),
                    ),
                  );
                },
              ),
              10.verticalSpace,
              MainButton(
                text: 'Manage Class',
                icon: const Icon(Icons.edit_rounded),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ManageEnrollmentsScreen(),
                  ),
                ),
              ),
              10.verticalSpace,
              MainButton(
                text: 'Password Reset Requests',
                icon: const Icon(Icons.lock_rounded),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PasswordResetRequestsScreen(),
                  ),
                ),
              ),
              10.verticalSpace,
              MainButton(
                text: 'Sign Out',
                icon: const Icon(Icons.logout_rounded),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
