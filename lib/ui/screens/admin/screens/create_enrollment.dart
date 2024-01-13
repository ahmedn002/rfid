import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/model/entities/course.dart';
import 'package:rfid_system/model/entities/student.dart';
import 'package:rfid_system/model/entities/teacher.dart';
import 'package:rfid_system/services/course_services.dart';
import 'package:rfid_system/services/enrollment_services.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/services/student_services.dart';
import 'package:rfid_system/services/teacher_services.dart';
import 'package:rfid_system/tools/send_data_service_handler.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/screens/auth/components/input_field.dart';
import 'package:rfid_system/ui/utilities/date_utilities.dart';
import 'package:rfid_system/ui/widgets/api%20widgets/RequestWidget.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';
import 'package:rfid_system/ui/widgets/buttons/main_button.dart';
import 'package:rfid_system/ui/widgets/buttons/secondary_button.dart';
import 'package:rfid_system/ui/widgets/input/drop_down_menu.dart';

import '../../../../model/entities/enrollment.dart';

final List<String> days = ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];

class CreateEnrollmentScreen extends StatefulWidget {
  final bool edit;
  final Enrollment? enrollment;
  final void Function(Enrollment)? onEnrollmentEdit;
  const CreateEnrollmentScreen({super.key, this.edit = false, this.enrollment, this.onEnrollmentEdit});

  @override
  State<CreateEnrollmentScreen> createState() => _CreateEnrollmentScreenState();
}

class _CreateEnrollmentScreenState extends State<CreateEnrollmentScreen> {
  // Components: Select a course,select days, select hours for each session, select number of sessions, select students, select teacher
  final TextEditingController _enrollmentNameController = TextEditingController();
  String _courseId = '';
  String _courseName = '';
  String _courseCode = '';
  String _teacherId = '';
  List<String> _selectedDays = [];
  final Map<String, DateTime> _dayStartHours = {};
  int _hours = 1;
  int _sessions = 1;
  DateTime _startDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  String _searchParameter = '';
  RangeValues _levelRangeValues = const RangeValues(1, 10);
  int _minRange = 1;
  final List<String> _studentIds = [];
  List<Color> _studentColors = [];

  final Future<FirebaseResponseWrapper<List<Course>?>> _getCourses = CourseServices.getCourses();
  final Future<FirebaseResponseWrapper<List<Teacher>?>> _getTeachers = TeacherServices.getTeachers();
  final Future<FirebaseResponseWrapper<List<Student>>> _getStudents = StudentServices.getStudents();

  @override
  void initState() {
    if (widget.edit) {
      _enrollmentNameController.text = widget.enrollment!.name;
      _courseId = widget.enrollment!.courseId;
      _courseName = widget.enrollment!.courseName;
      _courseCode = widget.enrollment!.courseCode;
      _teacherId = widget.enrollment!.teacherId;
      _selectedDays = widget.enrollment!.days.keys.toList();
      _dayStartHours.addAll(widget.enrollment!.days);
      _hours = widget.enrollment!.hours;
      _sessions = widget.enrollment!.sessions;
      _startDate = widget.enrollment!.startDate;
      _studentIds.addAll(widget.enrollment!.studentIds);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar('${widget.edit ? 'Edit' : 'Create'} Class'),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: MainButton(
          text: '${widget.edit ? 'Edit' : 'Create'} Class',
          icon: Icon(widget.edit ? Icons.edit : Icons.add_rounded),
          onPressed: widget.edit ? _editEnrollment : _addEnrollment,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,
                  InputField(
                    controller: _enrollmentNameController,
                    hintText: 'Class Name',
                    icon: Icons.edit_rounded,
                  ),
                  20.verticalSpace,
                  RequestWidget<List<Course>?>(
                    request: () => _getCourses,
                    successWidgetBuilder: (List<Course>? courses) {
                      if (courses == null) {
                        return const Center(child: Text('Unable to fetch courses.'));
                      } else if (courses.isEmpty) {
                        return const Center(child: Text('No courses found.'));
                      }

                      return DropDownMenu(
                        items: {for (var e in courses) e.id: e.name},
                        onChanged: (value) {
                          setState(() {
                            _courseId = value.toString();
                            _courseName = courses.firstWhere((element) => element.id == value).name;
                            _courseCode = courses.firstWhere((element) => element.id == value).code;
                            _minRange = courses.firstWhere((element) => element.id == value).level;
                            _levelRangeValues = RangeValues(_minRange.toDouble(), 10);
                          });
                        },
                        dropDownMenuItems: courses
                            .map<DropdownMenuItem>(
                              (e) => DropdownMenuItem(
                                value: e.id,
                                child: Row(
                                  children: [
                                    Text('${e.code} - '),
                                    Expanded(child: Text(e.name, overflow: TextOverflow.ellipsis)),
                                    Text('Level: ${e.level}'),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        value: _courseId.isEmpty ? null : _courseId,
                        hint: 'Select a course',
                        icon: Icons.book_rounded,
                      );
                    },
                  ),
                  20.verticalSpace,
                  RequestWidget(
                    request: () => _getTeachers,
                    successWidgetBuilder: (teachers) {
                      if (teachers == null) {
                        return const Center(child: Text('Unable to fetch teachers.'));
                      } else if (teachers.isEmpty) {
                        return const Center(child: Text('No teachers found.'));
                      }

                      return DropDownMenu(
                        items: {for (var e in teachers) e.id: '${e.firstName} ${e.lastName}'},
                        onChanged: (value) {
                          setState(() {
                            _teacherId = value.toString();
                          });
                        },
                        dropDownMenuItems: teachers
                            .map<DropdownMenuItem>(
                              (e) => DropdownMenuItem(
                                value: e.id,
                                child: Row(
                                  children: [
                                    Text('${e.id}: '),
                                    Expanded(child: Text('${e.firstName} ${e.lastName}', overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        value: _teacherId.isEmpty ? null : _teacherId,
                        hint: 'Select a teacher',
                        icon: Icons.person_rounded,
                      );
                    },
                  ),
                  20.verticalSpace,
                  Text(
                    'Select days:',
                    style: TextStyles.title,
                  ),
                  10.verticalSpace,
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
                        .map(
                          (e) => ListTile(
                            title: Text(e, style: TextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _selectedDays.contains(e)
                                    ? SecondaryButton(
                                        text: DateUtilities.formatTime(_dayStartHours[e]!),
                                        onPressed: () async {
                                          final TimeOfDay? picked = await showTimePicker(
                                            context: context,
                                            initialTime: DateUtilities.dateToTimeOfDay(_dayStartHours[e]!),
                                          );
                                          if (picked != null) {
                                            // Find the nearest date of the selected day
                                            DateTime nearestDate = _startDate;
                                            while (nearestDate.weekday != days.indexOf(e) + 1) {
                                              nearestDate = nearestDate.add(const Duration(days: 1));
                                            }
                                            setState(() {
                                              _dayStartHours[e] = DateTime(nearestDate.year, nearestDate.month, nearestDate.day, picked.hour, picked.minute);
                                            });
                                          }
                                        },
                                        thin: true,
                                        shrinkWrap: true,
                                      )
                                    : Container(),
                                10.horizontalSpace,
                                _selectedDays.contains(e)
                                    ? const Icon(Icons.check_circle_rounded, color: AppColors.accent)
                                    : const Icon(Icons.circle_outlined, color: AppColors.textPrimary),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                if (_selectedDays.contains(e)) {
                                  _selectedDays.remove(e);
                                  _dayStartHours.remove(e);
                                } else {
                                  _selectedDays.add(e);
                                  _dayStartHours[e] = DateTime(_startDate.year, _startDate.month, _startDate.day, 8, 0);
                                }
                              });
                            },
                            splashColor: AppColors.lightAccent,
                          ),
                        )
                        .toList(),
                  ),
                  Text(
                    'Select hours:',
                    style: TextStyles.title,
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: Slider(
                          value: _hours.toDouble(),
                          min: 1,
                          max: 4,
                          divisions: 3,
                          label: _hours.toString(),
                          onChanged: (double value) {
                            setState(() {
                              _hours = value.toInt();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text('$_hours hour(s)'),
                      ),
                    ],
                  ),
                  20.verticalSpace,
                  if (!widget.edit) ...[
                    Text(
                      'Select sessions:',
                      style: TextStyles.title,
                    ),
                    10.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: Slider(
                            value: _sessions.toDouble(),
                            min: 1,
                            max: 14,
                            divisions: 13,
                            label: _sessions.toString(),
                            onChanged: (double value) {
                              setState(() {
                                _sessions = value.toInt();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('$_sessions session(s)'),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                  ],
                  if (!widget.edit) ...[
                    Text(
                      'Select start date:',
                      style: TextStyles.title,
                    ),
                    10.verticalSpace,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: InputField(
                              controller: TextEditingController(
                                text: _startDate == DateTime.now() ? 'Today' : DateUtilities.formatDate(_startDate),
                              ),
                              hintText: 'Start Date',
                              icon: Icons.calendar_today_rounded,
                              enabled: false,
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: _startDate,
                                  firstDate: _startDate,
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null && picked != _startDate) {
                                  setState(() {
                                    _startDate = picked;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            20.verticalSpace,
            RequestWidget<List<Student>?>(
              request: () => _getStudents,
              successWidgetBuilder: (List<Student>? students) {
                if (students == null) {
                  return const Center(child: Text('Unable to fetch students.'));
                } else if (students.isEmpty) {
                  return const Center(child: Text('No students found.'));
                }

                if (_studentColors.isEmpty) {
                  _studentColors = List.generate(students.length, (index) => _getRandomMaterialColor());
                }

                // Filteration:
                if (_searchParameter.isNotEmpty) {
                  students = students.where(
                    (element) {
                      return element.firstName.contains(_searchParameter) ||
                          element.lastName.contains(_searchParameter) ||
                          element.studentID.contains(_searchParameter) ||
                          _searchParameter.contains(element.firstName) ||
                          _searchParameter.contains(element.lastName) ||
                          _searchParameter.contains(element.studentID);
                    },
                  ).toList();
                }

                if (_levelRangeValues != const RangeValues(1, 10)) {
                  students = students.where((element) => element.studentLevel >= _levelRangeValues.start && element.studentLevel <= _levelRangeValues.end).toList();
                }

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Material(
                    color: AppColors.background,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 10,
                                    child: InputField(
                                      controller: _searchController,
                                      onChanged: (value) {
                                        setState(() {
                                          _searchParameter = value;
                                        });
                                      },
                                      hintText: 'Search...',
                                      icon: Icons.search_rounded,
                                      suffixIcon: _searchController.text.isNotEmpty
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _searchController.clear();
                                                  _searchParameter = '';
                                                  FocusScope.of(context).unfocus();
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.close_rounded,
                                                color: AppColors.accent,
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                  10.horizontalSpace,

                                  // Number of students selected
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      '${_studentIds.length} selected',
                                      style: TextStyles.body.copyWith(fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              10.verticalSpace,
                              Row(
                                children: [
                                  Text(
                                    'Level: ',
                                    style: TextStyles.body.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Expanded(
                                    child: RangeSlider(
                                      values: _levelRangeValues,
                                      min: _minRange.toDouble(),
                                      max: 10,
                                      divisions: 10 - _minRange,
                                      labels: RangeLabels(
                                        _levelRangeValues.start.round().toString(),
                                        _levelRangeValues.end.round().toString(),
                                      ),
                                      onChanged: (RangeValues values) {
                                        setState(() {
                                          _levelRangeValues = values;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ...students
                                .map(
                                  (e) => ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: _studentColors[students!.indexOf(e)],
                                      child: Text(
                                        '${e.firstName[0]}${e.lastName[0]}',
                                        style: TextStyles.body.copyWith(color: AppColors.background),
                                      ),
                                    ),
                                    enableFeedback: true,
                                    trailing: _studentIds.contains(e.id)
                                        ? const Icon(Icons.check_circle_rounded, color: AppColors.accent)
                                        : const Icon(Icons.circle_outlined, color: AppColors.textPrimary),
                                    onTap: () {
                                      HapticFeedback.vibrate();
                                      setState(() {
                                        if (_studentIds.contains(e.id)) {
                                          _studentIds.remove(e.id);
                                        } else {
                                          _studentIds.add(e.id);
                                        }
                                      });
                                    },
                                    splashColor: AppColors.lightAccent,
                                    title: Text('${e.studentID}: ${e.firstName} ${e.lastName}', style: TextStyles.body),
                                    subtitle: Text('Level: ${e.studentLevel}', style: TextStyles.body.apply(color: AppColors.textSecondary)),
                                  ),
                                )
                                .toList(),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            100.verticalSpace,
          ],
        ),
      ),
    );
  }

  Color _getRandomMaterialColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  void _editEnrollment() async {
    if (_courseId.isEmpty || _teacherId.isEmpty || _selectedDays.isEmpty || _hours == 0 || _sessions == 0 || _studentIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields.'),
          backgroundColor: AppColors.accent,
        ),
      );
      return;
    }

    RequestHandler.handleRequest(
        context: context,
        service: () => EnrollmentServices.editEnrollment(
              Enrollment(
                id: widget.enrollment!.id,
                name: _enrollmentNameController.text,
                courseId: _courseId,
                courseName: _courseName,
                courseCode: _courseCode,
                teacherId: _teacherId,
                days: _dayStartHours,
                hours: _hours,
                sessions: _sessions,
                studentIds: _studentIds,
                startDate: _startDate,
              ),
            ),
        onSuccess: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          widget.onEnrollmentEdit?.call(
            Enrollment(
              id: widget.enrollment!.id,
              name: _enrollmentNameController.text,
              courseId: _courseId,
              courseName: _courseName,
              courseCode: _courseCode,
              teacherId: _teacherId,
              days: _dayStartHours,
              hours: _hours,
              sessions: _sessions,
              studentIds: _studentIds,
              startDate: _startDate,
            ),
          );
        });
  }

  void _addEnrollment() async {
    if (_courseId.isEmpty || _teacherId.isEmpty || _selectedDays.isEmpty || _hours == 0 || _sessions == 0 || _studentIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields.'),
          backgroundColor: AppColors.accent,
        ),
      );
      return;
    }

    RequestHandler.handleRequest(
      context: context,
      service: () => EnrollmentServices.addEnrollment(
        Enrollment(
          name: _enrollmentNameController.text,
          courseId: _courseId,
          courseName: _courseName,
          courseCode: _courseCode,
          teacherId: _teacherId,
          days: _dayStartHours,
          hours: _hours,
          sessions: _sessions,
          studentIds: _studentIds,
          startDate: _startDate,
        ),
      ),
    );
  }
}
