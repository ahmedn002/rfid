import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/model/entities/session.dart';
import 'package:rfid_system/model/ui/course_data.dart';
import 'package:rfid_system/services/session_services.dart';
import 'package:rfid_system/tools/send_data_service_handler.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/screens/auth/components/input_field.dart';
import 'package:rfid_system/ui/screens/teacher/concluded%20session/concluded_session.dart';
import 'package:rfid_system/ui/utilities/date_utilities.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';
import 'package:rfid_system/ui/widgets/buttons/main_button.dart';
import 'package:rfid_system/ui/widgets/buttons/secondary_button.dart';

class ManageSessionScreen extends StatefulWidget {
  final Session session;
  final CourseData courseData;
  final void Function()? onSessionEdit;
  const ManageSessionScreen({super.key, required this.session, required this.courseData, this.onSessionEdit});

  @override
  State<ManageSessionScreen> createState() => _ManageSessionScreenState();
}

class _ManageSessionScreenState extends State<ManageSessionScreen> {
  DateTime _selectedExpectedStartTime = DateTime.now(); // Only editable session detail

  @override
  void initState() {
    _selectedExpectedStartTime = widget.session.expectedStartTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar('Session #${widget.courseData.getSessionIndex(widget.session) + 1}'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Start Time', style: TextStyles.title),
            10.verticalSpace,
            InputField(
              hintText: 'Start Time',
              controller: TextEditingController(text: DateUtilities.formatDateTime(_selectedExpectedStartTime)),
              enabled: false,
              icon: Icons.calendar_today,
              suffixIcon: const Icon(Icons.arrow_drop_down),
              onTap: () async {
                final DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedExpectedStartTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null && context.mounted) {
                  final TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_selectedExpectedStartTime),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      _selectedExpectedStartTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  }
                }
              },
            ),
            20.verticalSpace,
            MainButton(
              text: 'Edit Session',
              icon: const Icon(Icons.edit_rounded),
              onPressed: () async {
                await RequestHandler.handleRequest(
                  context: context,
                  service: () => SessionServices.rewriteSession(widget.session.copyWith(expectedStartTime: _selectedExpectedStartTime)),
                  onSuccess: () {
                    widget.onSessionEdit?.call();
                  },
                );
              },
            ),
            20.verticalSpace,
            if (widget.session.concluded) ...[
              MainButton(
                text: 'View Attendance',
                icon: const Icon(Icons.people_alt_rounded),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConcludedSessionScreen(
                        session: widget.session,
                        courseData: widget.courseData,
                        onAttendanceUpdate: () {
                          widget.onSessionEdit?.call();
                        },
                      ),
                    ),
                  );
                },
              ),
              20.verticalSpace,
            ],
            SecondaryButton(
              text: 'Delete Session',
              icon: const Icon(Icons.delete_rounded),
              onPressed: () {
                Navigator.pop(context, true);
                widget.onSessionEdit?.call();
              },
            )
          ],
        ),
      ),
    );
  }
}
