import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/model/ui/course_data.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/screens/teacher/dashboard/components/course_card.dart';
import 'package:rfid_system/ui/screens/teacher/dashboard/components/session_tile.dart';
import 'package:rfid_system/ui/utilities/misc_utilities.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';

class TeacherCourseDetails extends StatefulWidget {
  final CourseData courseData;
  const TeacherCourseDetails({super.key, required this.courseData});

  @override
  State<TeacherCourseDetails> createState() => _TeacherCourseDetailsState();
}

class _TeacherCourseDetailsState extends State<TeacherCourseDetails> {
  final Color _color = MiscUtilities.getRandomMaterialColor();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RFIDAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CourseCard(
              courseData: widget.courseData,
            ),
            20.verticalSpace,
            Text('Sessions', style: TextStyles.title),
            10.verticalSpace,
            Expanded(
                child: ListView.separated(
              itemCount: widget.courseData.sessions.length,
              itemBuilder: (context, index) => SessionTile(
                sessionData: {
                  widget.courseData.getSortedSessions()[index]: {
                    'courseCode': widget.courseData.courseCode,
                    'courseName': widget.courseData.courseName,
                    'sessionIndex': index,
                  }
                },
                color: _color,
              ),
              separatorBuilder: (context, index) => 16.verticalSpace,
            )),
          ],
        ),
      ),
    );
  }
}
