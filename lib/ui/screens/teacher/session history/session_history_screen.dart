import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rfid_system/ui/screens/teacher/concluded%20session/components/session_card.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_data_provider.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_request_provider.dart';

import '../../../../model/entities/session.dart';
import '../../../../model/ui/teacher_dashboard_model.dart';
import '../../../widgets/api widgets/RequestWidget.dart';
import '../concluded session/concluded_session.dart';

class TeacherSessionHistory extends StatefulWidget {
  const TeacherSessionHistory({super.key});

  @override
  State<TeacherSessionHistory> createState() => _TeacherSessionHistoryState();
}

class _TeacherSessionHistoryState extends State<TeacherSessionHistory> {
  late List<Session> _sessionHistory;

  @override
  Widget build(BuildContext context) {
    return Consumer2<TeacherRequestProvider, TeacherDataProvider>(
      builder: (context, teacherRequestProvider, teacherDataProvider, _) => RequestWidget(
        request: () => teacherRequestProvider.getTeacherDashboardModel,
        successWidgetBuilder: (TeacherDashboardModel model) {
          _sessionHistory = model.getSessionHistory();
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.separated(
              itemCount: _sessionHistory.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConcludedSessionScreen(session: _sessionHistory[index]),
                  ),
                ),
                child: SessionCard(
                  session: _sessionHistory[index],
                  courseData: teacherDataProvider.teacherDashboardModel.getCourseDataFromSession(_sessionHistory[index])!,
                ),
              ),
              separatorBuilder: (context, index) => 16.verticalSpace,
            ),
          );
        },
      ),
    );
  }
}
