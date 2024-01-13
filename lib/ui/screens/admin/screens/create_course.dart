import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/model/entities/course.dart';
import 'package:rfid_system/tools/send_data_service_handler.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/screens/auth/components/input_field.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';
import 'package:rfid_system/ui/widgets/buttons/main_button.dart';

import '../../../../services/course_services.dart';

class CreateCourseScreen extends StatefulWidget {
  final bool edit;
  final Course? course;
  final void Function()? onCourseEdit;
  const CreateCourseScreen({super.key, this.edit = false, this.course, this.onCourseEdit});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  // Level slider from ints 1 to 10
  int _level = 1;

  //Inputs for course code, course name
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _courseNameController = TextEditingController();

  @override
  void initState() {
    if (widget.edit) {
      _courseCodeController.text = widget.course!.code;
      _courseNameController.text = widget.course!.name;
      _level = widget.course!.level;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar('${widget.edit ? 'Edit' : 'Create'} Course'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Range slider
            Text('Select course level:', style: TextStyles.title),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _level.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _level.toString(),
                    onChanged: (double value) {
                      setState(() {
                        _level = value.round();
                      });
                    },
                  ),
                ),
                Text(
                  'Level: $_level',
                  style: TextStyles.body,
                )
              ],
            ),
            Divider(
              thickness: 2.h,
              color: AppColors.textPrimary,
            ),
            20.verticalSpace,
            Form(
              child: Column(
                children: [
                  InputField(
                    controller: _courseCodeController,
                    hintText: 'Enter course code',
                    icon: Icons.numbers_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Course code cannot be empty';
                      }
                      return null;
                    },
                  ),
                  10.verticalSpace,
                  InputField(
                    controller: _courseNameController,
                    hintText: 'Enter course name',
                    icon: Icons.text_fields_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Course name cannot be empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            MainButton(
              text: '${widget.edit ? 'Edit' : 'Create'} Course',
              icon: Icon(widget.edit ? Icons.edit_rounded : Icons.add_rounded),
              onPressed: () {
                if (widget.edit) {
                  RequestHandler.handleRequest(
                    context: context,
                    service: () => CourseServices.editCourse(
                      Course(
                        id: widget.course!.id,
                        code: _courseCodeController.text,
                        name: _courseNameController.text,
                        level: _level,
                      ),
                    ),
                    onSuccess: () {
                      widget.onCourseEdit?.call();
                      Navigator.of(context).pop();
                    },
                  );
                  return;
                }
                RequestHandler.handleRequest(
                  context: context,
                  service: () => CourseServices.addCourse(
                    Course(
                      code: _courseCodeController.text,
                      name: _courseNameController.text,
                      level: _level,
                    ),
                  ),
                  onSuccess: () {
                    _courseCodeController.clear();
                    _courseNameController.clear();
                    setState(() {
                      _level = 1;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
