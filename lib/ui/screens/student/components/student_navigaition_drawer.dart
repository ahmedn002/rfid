import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/providers/auth_provider.dart';
import 'package:rfid_system/ui/screens/auth/signin/signin_screen.dart';
import 'package:rfid_system/ui/screens/student/provider/student_navigation_provider.dart';
import 'package:rfid_system/ui/widgets/buttons/secondary_button.dart';

class StudentNavigationDrawer extends StatelessWidget {
  const StudentNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<StudentNavigationProvider, AuthenticationProvider>(
      builder: (context, studentNavigationProvider, authenticationProvider, _) => ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        child: NavigationDrawer(
          selectedIndex: studentNavigationProvider.currentIndex,
          indicatorColor: AppColors.accent,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(
                color: AppColors.foregroundOne,
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40.r,
                      backgroundColor: AppColors.foregroundTwo,
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.textPrimary,
                        size: 40.r,
                      ),
                    ),
                    8.verticalSpace,
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 0.5.sw),
                            child: Text(
                              '${authenticationProvider.student.firstName} ${authenticationProvider.student.lastName}',
                              style: TextStyles.title.apply(
                                color: AppColors.textPrimary,
                                fontWeightDelta: 1,
                              ),
                            ),
                          ),
                          4.horizontalSpace,
                          Container(
                            padding: EdgeInsets.all(5.r),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: AppColors.success.withOpacity(0.25),
                            ),
                            child: Text(
                              'Student',
                              style: TextStyles.bodySmall.apply(
                                color: AppColors.success,
                                fontWeightDelta: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            16.verticalSpace,
            NavigationTile(
              title: 'Dashboard',
              icon: Icons.dashboard_rounded,
              selected: studentNavigationProvider.currentIndex == 0,
              onTap: () {
                studentNavigationProvider.setCurrentIndex(0);
                Navigator.of(context).pop();
              },
            ),
            Divider(
              color: AppColors.foregroundTwo,
              thickness: 2.r,
              indent: 16.w,
              endIndent: 16.w,
              height: 24.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: SecondaryButton(
                icon: Icon(Icons.logout_rounded, size: 18.r),
                text: 'Logout',
                onPressed: () {
                  authenticationProvider.isSignedIn = false;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;
  final bool selected;
  const NavigationTile({super.key, required this.title, required this.icon, this.onTap, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.r),
        child: Material(
          color: selected ? AppColors.lightAccent.withOpacity(0.5) : Colors.transparent,
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
            leading: Icon(
              icon,
              color: selected ? AppColors.accent : AppColors.textPrimary,
            ),
            selected: selected,
            splashColor: AppColors.accent,
            title: Text(
              title,
              style: TextStyles.body,
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
