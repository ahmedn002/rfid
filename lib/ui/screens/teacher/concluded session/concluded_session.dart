import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rfid_system/model/entities/session.dart';
import 'package:rfid_system/model/ui/course_data.dart';
import 'package:rfid_system/model/ui/full_session.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/services/teacher_services.dart';
import 'package:rfid_system/tools/send_data_service_handler.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/lookups.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/providers/auth_provider.dart';
import 'package:rfid_system/ui/screens/teacher/concluded%20session/components/session_card.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_data_provider.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_request_provider.dart';
import 'package:rfid_system/ui/utilities/misc_utilities.dart';
import 'package:rfid_system/ui/widgets/api%20widgets/RequestWidget.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';

import '../../../../model/entities/student.dart';
import '../../../../services/session_services.dart';

class ConcludedSessionScreen extends StatefulWidget {
  final Session session;
  final CourseData? courseData;
  final void Function()? onAttendanceUpdate;
  const ConcludedSessionScreen({super.key, required this.session, this.courseData, this.onAttendanceUpdate});

  @override
  State<ConcludedSessionScreen> createState() => _ConcludedSessionScreenState();
}

class _ConcludedSessionScreenState extends State<ConcludedSessionScreen> {
  late final Future<FirebaseResponseWrapper<FullSession?>> _sessionDetailsRequest;
  late final CourseData? _courseData;
  late final Map<Student, String> _attendanceMap;
  late final Map<Student, Color> _studentColors;

  bool _initializedAttendanceMap = false;

  @override
  void initState() {
    _sessionDetailsRequest = SessionServices.getFullSession(widget.session.id);
    if (widget.courseData != null) {
      _courseData = widget.courseData;
    } else {
      _courseData = Provider.of<TeacherDataProvider>(context, listen: false).teacherDashboardModel.getCourseDataFromSession(widget.session);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RFIDAppBar(),
      body: RequestWidget(
        request: () => _sessionDetailsRequest,
        successWidgetBuilder: (FullSession? fullSession) {
          if (fullSession == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!_initializedAttendanceMap) {
            _attendanceMap = fullSession.getAttendanceMap();
            _studentColors = {for (var student in _attendanceMap.keys) student: MiscUtilities.getRandomMaterialColor()};
            _initializedAttendanceMap = true;
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SessionCard(
                    session: widget.session,
                    courseData: _courseData!,
                  ),
                  16.verticalSpace,
                  Text(
                    'Attendance',
                    style: TextStyles.title,
                  ),
                  16.verticalSpace,
                  Expanded(
                    child: ListView.builder(
                      itemCount: fullSession.getAttendanceCount(),
                      itemBuilder: (context, index) {
                        final Student student = _attendanceMap.keys.elementAt(index);
                        final String state = _attendanceMap[student]!;

                        return Container(
                          margin: EdgeInsets.only(bottom: 8.h),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Material(
                            color: AppColors.foregroundOne,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _studentColors[student],
                                child: Text('${student.firstName[0]}${student.lastName[0]}', style: TextStyles.body),
                              ),
                              title: Text(
                                '${student.studentID} - ${student.firstName} ${student.lastName}',
                                style: TextStyles.body,
                              ),
                              subtitle: Text(
                                state,
                                style: TextStyles.body.apply(
                                  color: state == Lookups.attended ? AppColors.success : AppColors.fail,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  // show drop down containing three states in lookup [attended, absent, sick leave]

                                  final List<String> states = [Lookups.attended, Lookups.absent, Lookups.sickLeave];
                                  final List<IconData> icons = [Icons.check_circle_rounded, Icons.cancel_rounded, Icons.sick_rounded];
                                  final List<Color> colors = [AppColors.success, AppColors.fail, AppColors.warning];

                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Container(
                                      padding: EdgeInsets.symmetric(vertical: 16.h),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          for (int i = 0; i < states.length; i++)
                                            ListTile(
                                              leading: Icon(icons[i], color: colors[i]),
                                              title: Text(states[i]),
                                              onTap: () async {
                                                await _handleStateChange(student, states[i]);
                                                Navigator.pop(context);
                                                widget.onAttendanceUpdate?.call();
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit_rounded, size: 20.r),
                                splashRadius: 20.r,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleStateChange(Student student, String state) async {
    // if state change is the same as old state, do nothing
    if (_attendanceMap[student] == state) return;

    // find which list contains student
    if (widget.session.attended.contains(student.id)) {
      // remove from attended
      widget.session.attended.remove(student.id);
    } else if (widget.session.absent.contains(student.id)) {
      // remove from absent
      widget.session.absent.remove(student.id);
    } else if (widget.session.sickLeave.contains(student.id)) {
      // remove from sick leave
      widget.session.sickLeave.remove(student.id);
    }

    if (state == Lookups.attended) {
      widget.session.attended.add(student.id);
    } else if (state == Lookups.absent) {
      widget.session.absent.add(student.id);
    } else if (state == Lookups.sickLeave) {
      widget.session.sickLeave.add(student.id);
    }

    // update session
    await RequestHandler.handleRequest(
      context: context,
      service: () => SessionServices.rewriteSession(widget.session),
      onSuccess: () {
        // update attendance map
        setState(() {
          _attendanceMap[student] = state;
        });
        Provider.of<TeacherRequestProvider>(context, listen: false).setTeacherDashboardModel(
          TeacherServices.getTeacherDashboardModel(
            Provider.of<AuthenticationProvider>(context, listen: false).teacher.id,
          ),
        );
      },
    );
  }
}
