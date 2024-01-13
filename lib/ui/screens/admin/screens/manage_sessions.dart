import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/model/entities/enrollment.dart';
import 'package:rfid_system/model/entities/session.dart';
import 'package:rfid_system/model/ui/course_data.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/services/session_services.dart';
import 'package:rfid_system/ui/screens/admin/screens/manage_session.dart';
import 'package:rfid_system/ui/screens/teacher/concluded%20session/components/session_card.dart';
import 'package:rfid_system/ui/widgets/api%20widgets/RequestWidget.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';

class ManageSessionsScreen extends StatefulWidget {
  final Enrollment enrollment;
  const ManageSessionsScreen({super.key, required this.enrollment});

  @override
  State<ManageSessionsScreen> createState() => _ManageSessionsScreenState();
}

class _ManageSessionsScreenState extends State<ManageSessionsScreen> {
  late Future<FirebaseResponseWrapper<List<Session>>> _sessionsRequest;
  late CourseData _courseData;

  @override
  void initState() {
    _sessionsRequest = SessionServices.getSessionsForEnrollment(widget.enrollment.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar('${widget.enrollment.name} Sessions'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: RequestWidget(
          request: () => _sessionsRequest,
          successWidgetBuilder: (List<Session> sessions) {
            _courseData = CourseData(
              courseCode: widget.enrollment.courseCode,
              courseName: widget.enrollment.courseName,
              sessions: sessions,
            );

            return ListView.separated(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final Session session = sessions[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageSessionScreen(
                        session: session,
                        courseData: _courseData,
                        onSessionEdit: () {
                          setState(() {
                            _sessionsRequest = SessionServices.getSessionsForEnrollment(widget.enrollment.id);
                          });
                        },
                      ),
                    ),
                  ),
                  child: SessionCard(
                    session: session,
                    courseData: _courseData,
                  ),
                );
              },
              separatorBuilder: (context, index) => 16.verticalSpace,
            );
          },
        ),
      ),
    );
  }
}
