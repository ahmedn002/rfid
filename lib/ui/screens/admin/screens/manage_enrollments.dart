import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/model/entities/enrollment.dart';
import 'package:rfid_system/services/enrollment_services.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/screens/admin/screens/manage_enrollment_options.dart';
import 'package:rfid_system/ui/utilities/date_utilities.dart';
import 'package:rfid_system/ui/widgets/api%20widgets/RequestWidget.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';

class ManageEnrollmentsScreen extends StatefulWidget {
  const ManageEnrollmentsScreen({super.key});

  @override
  State<ManageEnrollmentsScreen> createState() => _ManageEnrollmentsScreenState();
}

class _ManageEnrollmentsScreenState extends State<ManageEnrollmentsScreen> {
  Future<FirebaseResponseWrapper<List<Enrollment>>> _getEnrollments = EnrollmentServices.getEnrollments();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar('Manage Classes'),
      body: RequestWidget<List<Enrollment>>(
        request: () => _getEnrollments,
        successWidgetBuilder: (List<Enrollment> enrollments) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.separated(
              itemCount: enrollments.length,
              itemBuilder: (context, index) {
                final Enrollment enrollment = enrollments[index];
                return Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: AppColors.foregroundOne,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(5.r),
                              color: AppColors.accent,
                              child: Text(
                                '${enrollment.courseCode} - ${enrollment.courseName}',
                                style: TextStyles.body.apply(color: AppColors.background),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(5.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13.r),
                            color: AppColors.accent,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                enrollment.studentIds.length.toString(),
                                style: const TextStyle(color: AppColors.background),
                              ),
                              Text(
                                'Students',
                                style: TextStyles.bodySmall.apply(color: AppColors.background),
                              ),
                            ],
                          ),
                        ),
                        title: Text(enrollment.name),
                        subtitle: Text(
                          enrollment.days.keys.map((key) => '$key: ${DateUtilities.formatTime(enrollment.days[key]!)}').join('\n'),
                          style: TextStyles.bodySmall,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit_rounded),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ManageEnrollmentOptionsScreen(
                                enrollment: enrollment,
                                onEnrollmentEdit: (Enrollment enrollment) {
                                  setState(() {
                                    _getEnrollments = EnrollmentServices.getEnrollments();
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
