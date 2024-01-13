import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/model/entities/session.dart';
import 'package:rfid_system/model/ui/course_data.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/text_styles.dart';
import '../../../../utilities/date_utilities.dart';

class SessionCard extends StatelessWidget {
  final Session session;
  final CourseData courseData;
  const SessionCard({super.key, required this.session, required this.courseData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.foregroundOne,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      courseData.courseCode,
                      style: TextStyles.title.apply(
                        color: AppColors.secondaryAccent,
                        fontWeightDelta: 1,
                      ),
                    ),
                    session.concluded ? _buildAttendanceLabel() : _buildHasntStartedLabel(),
                  ],
                ),
                8.verticalSpace,
                Text(
                  courseData.courseName,
                  style: TextStyles.title.apply(
                    color: AppColors.accent,
                    fontWeightDelta: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                8.verticalSpace,
                Text(
                  'Session ${courseData.getSessionIndex(session) + 1}',
                  style: TextStyles.title.apply(
                    color: AppColors.textPrimary,
                    fontWeightDelta: 1,
                  ),
                ),
                8.verticalSpace,
                if (session.concluded) keyValueRichText('Concluded at: ', DateUtilities.formatDateTime(session.endTime ?? DateTime.now())),
                if (!session.concluded) keyValueRichText('Starts at: ', DateUtilities.formatDateTime(session.expectedStartTime)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceLabel() {
    final backgroundColor = session.calculateAttendance() > 50 ? AppColors.success.withOpacity(0.25) : AppColors.fail.withOpacity(0.25);
    final textColor = session.calculateAttendance() > 50 ? AppColors.success : AppColors.fail;
    return Container(
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: backgroundColor,
      ),
      child: Text(
        'Attendance: ${session.calculateAttendance().toInt()}%',
        style: TextStyles.bodySmall.apply(
          color: textColor,
          fontWeightDelta: 2,
        ),
      ),
    );
  }

  Widget _buildHasntStartedLabel() {
    return Container(
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.accent.withOpacity(0.7),
      ),
      child: Text(
        'Hasn\'t Started',
        style: TextStyles.bodySmall.apply(
          color: AppColors.lightAccent,
          fontWeightDelta: 1,
        ),
      ),
    );
  }

  Widget keyValueRichText(String key, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: key,
            style: TextStyles.body.apply(
              color: AppColors.textPrimary,
              fontWeightDelta: 2,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyles.body.apply(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
