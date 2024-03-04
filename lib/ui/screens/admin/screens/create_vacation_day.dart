import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/model/entities/vacation.dart';
import 'package:rfid_system/tools/send_data_service_handler.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';
import 'package:rfid_system/ui/widgets/buttons/main_button.dart';

import '../../../../services/vacation_services.dart';

class CreateVacationDay extends StatefulWidget {
  final bool edit;
  final Vacation? vacation;
  final void Function()? onVacationEdit;
  const CreateVacationDay({super.key, this.edit = false, this.vacation, this.onVacationEdit});

  @override
  State<CreateVacationDay> createState() => _CreateVacationDayState();
}

class _CreateVacationDayState extends State<CreateVacationDay> {
  DateTime? _selectedVacationDate;

  @override
  void initState() {
    super.initState();
    if (widget.edit) {
      _selectedVacationDate = widget.vacation!.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar('${widget.edit ? 'Edit' : 'Create'} Vacation'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date picker
            Text('Select vacation date:', style: TextStyles.title),
            10.verticalSpace,
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (picked != null && picked != _selectedVacationDate) {
                  setState(() {
                    _selectedVacationDate = picked;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.foregroundOne,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, color: AppColors.accent),
                    10.horizontalSpace,
                    Text(
                      _selectedVacationDate == null ? 'Select a date' : '${_selectedVacationDate!.day}/${_selectedVacationDate!.month}/${_selectedVacationDate!.year}',
                      style: TextStyles.body,
                    ),
                  ],
                ),
              ),
            ),
            20.verticalSpace,
            MainButton(
              text: '${widget.edit ? 'Edit' : 'Create'} Vacation',
              onPressed: () async {
                if (_selectedVacationDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a date.'),
                    ),
                  );
                  return;
                }

                if (widget.edit) {
                  RequestHandler.handleRequest(
                    context: context,
                    service: () => VacationServices.updateVacation(widget.vacation!.id, _selectedVacationDate!),
                    onSuccess: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vacation updated successfully.'),
                        ),
                      );
                      widget.onVacationEdit?.call();
                    },
                  );
                } else {
                  RequestHandler.handleRequest(
                    context: context,
                    service: () => VacationServices.createVacation(_selectedVacationDate!),
                    onSuccess: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Vacation created successfully.'),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
