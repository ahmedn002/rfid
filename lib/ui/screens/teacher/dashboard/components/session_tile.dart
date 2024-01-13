import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/screens/teacher/concluded%20session/concluded_session.dart';
import 'package:rfid_system/ui/screens/teacher/dashboard/start_session.dart';
import 'package:rfid_system/ui/utilities/date_utilities.dart';
import 'package:rfid_system/ui/widgets/buttons/text_button.dart';

import '../../../../../model/entities/session.dart';

class SessionTile extends StatelessWidget {
  final Map<Session, Map> sessionData;
  final Color color;
  const SessionTile({super.key, required this.sessionData, required this.color});

  @override
  Widget build(BuildContext context) {
    final Session session = sessionData.keys.first;
    final Map sessionInfo = sessionData.values.first;
    final String courseCode = sessionInfo['courseCode'];
    final String courseName = sessionInfo['courseName'];
    final int sessionIndex = sessionInfo['sessionIndex'];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.h),
      decoration: BoxDecoration(
        color: AppColors.foregroundOne,
        borderRadius: BorderRadius.circular(27.r),
      ),
      child: Row(
        children: [
          2.horizontalSpace,
          Container(
            padding: EdgeInsets.all(5.r),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(19.r),
            ),
            child: Column(
              children: [
                Text(
                  courseCode,
                  style: TextStyles.bodySmall.apply(fontWeightDelta: 2),
                ),
                4.verticalSpace,
                Text(
                  '${sessionIndex + 1}',
                  style: TextStyles.title,
                ),
              ],
            ),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseName,
                  style: TextStyles.body.apply(
                    fontWeightDelta: 2,
                  ),
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateUtilities.formatDateTime(session.expectedStartTime),
                        style: TextStyles.bodySecondary.apply(fontSizeFactor: 0.9),
                      ),
                    ),
                    if (session.concluded)
                      Container(
                        padding: EdgeInsets.all(2.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: AppColors.success.withOpacity(0.25),
                        ),
                        child: Text(
                          'Concluded',
                          style: TextStyles.bodySecondary.apply(
                            color: AppColors.success,
                            fontSizeFactor: 0.7,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (session.concluded)
            MainTextButton(
              text: 'View',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConcludedSessionScreen(session: session)),
              ),
            ),
          if (!session.concluded)
            MainTextButton(
              text: 'Start',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StartSessionScreen(session: session)),
              ),
            ),
        ],
      ),
    );
  }
}
