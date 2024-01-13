import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/model/entities/enrollment.dart';
import 'package:rfid_system/ui/screens/admin/screens/create_enrollment.dart';
import 'package:rfid_system/ui/screens/admin/screens/manage_sessions.dart';
import 'package:rfid_system/ui/widgets/buttons/main_button.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';
import '../../../utilities/date_utilities.dart';
import '../../../widgets/app_bar.dart';

class ManageEnrollmentOptionsScreen extends StatefulWidget {
  final Enrollment enrollment;
  final void Function(Enrollment enrollment)? onEnrollmentEdit;
  const ManageEnrollmentOptionsScreen({super.key, required this.enrollment, this.onEnrollmentEdit});

  @override
  State<ManageEnrollmentOptionsScreen> createState() => _ManageEnrollmentOptionsScreenState();
}

class _ManageEnrollmentOptionsScreenState extends State<ManageEnrollmentOptionsScreen> {
  late Enrollment _enrollment;

  @override
  void initState() {
    _enrollment = widget.enrollment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar('Manage Class Options'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                            '${_enrollment.courseCode} - ${_enrollment.courseName}',
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
                            _enrollment.studentIds.length.toString(),
                            style: const TextStyle(color: AppColors.background),
                          ),
                          Text(
                            'Students',
                            style: TextStyles.bodySmall.apply(color: AppColors.background),
                          ),
                        ],
                      ),
                    ),
                    title: Text(_enrollment.name),
                    subtitle: Text(
                      _enrollment.days.keys.map((key) => '$key: ${DateUtilities.formatTime(_enrollment.days[key]!)}').join('\n'),
                      style: TextStyles.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            MainButton(
              text: 'Manage Class Info',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateEnrollmentScreen(
                    edit: true,
                    enrollment: _enrollment,
                    onEnrollmentEdit: (Enrollment enrollment) {
                      setState(() {
                        _enrollment = enrollment;
                      });
                      if (widget.onEnrollmentEdit != null) {
                        widget.onEnrollmentEdit!(_enrollment);
                      }
                    },
                  ),
                ),
              ),
            ),
            20.verticalSpace,
            MainButton(
              text: 'Manage Sessions',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageSessionsScreen(enrollment: _enrollment),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
