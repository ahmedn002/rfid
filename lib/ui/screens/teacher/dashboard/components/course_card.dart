import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rfid_system/model/ui/course_data.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/utilities/date_utilities.dart';

import '../../../../providers/auth_provider.dart';

class CourseCard extends StatefulWidget {
  final CourseData courseData;
  final bool isStudent;
  const CourseCard({
    super.key,
    required this.courseData,
    this.isStudent = false,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
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
                      widget.courseData.courseCode,
                      style: TextStyles.title.apply(
                        color: AppColors.secondaryAccent,
                        fontWeightDelta: 1,
                      ),
                    ),
                    if (widget.courseData.concludedSessionsCount > 0) _buildAttendanceLabel() else _buildHasntStartedLabel()
                  ],
                ),
                8.verticalSpace,
                Text(
                  widget.courseData.courseName,
                  style: TextStyles.title.apply(
                    color: AppColors.accent,
                    fontWeightDelta: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                8.verticalSpace,
                keyValueRichText('${widget.courseData.concludedSessionsCount}/${widget.courseData.totalSessions} ', 'Sessions'),
                8.verticalSpace,
                keyValueRichText('Next Session: ', widget.courseData.nextSession != null ? DateUtilities.formatDateTime(widget.courseData.nextSession!) : 'N/A'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceLabel() {
    final num attendance = widget.isStudent
        ? widget.courseData.getStudentAttendance(
            Provider.of<AuthenticationProvider>(context, listen: false).student.id,
          )
        : widget.courseData.attendance;
    final backgroundColor = attendance > 50 ? AppColors.success.withOpacity(0.25) : AppColors.fail.withOpacity(0.25);
    final textColor = attendance > 50 ? AppColors.success : AppColors.fail;
    return Container(
      padding: EdgeInsets.all(5.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: backgroundColor,
      ),
      child: Text(
        'Attendance: ${attendance.ceil()}%',
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
