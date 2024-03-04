import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/model/entities/vacation.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/services/vacation_services.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/screens/admin/screens/create_vacation_day.dart';
import 'package:rfid_system/ui/widgets/api%20widgets/RequestWidget.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';

class ManageVacationDaysScreen extends StatefulWidget {
  const ManageVacationDaysScreen({super.key});

  @override
  State<ManageVacationDaysScreen> createState() => _ManageVacationDaysScreenState();
}

class _ManageVacationDaysScreenState extends State<ManageVacationDaysScreen> {
  Future<FirebaseResponseWrapper<List<Vacation>>> _vacationsRequest = VacationServices.getVacations();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar('Manage Vacations'),
      body: RequestWidget(
        request: () => _vacationsRequest,
        successWidgetBuilder: (List<Vacation>? vacations) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.separated(
              itemCount: vacations!.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: AppColors.foregroundOne,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.accent,
                      child: Text(
                        '${index + 1}',
                        style: TextStyles.body.apply(color: AppColors.background),
                      ),
                    ),
                    title: Text(_formatDate(vacations[index].date)),
                    trailing: IntrinsicWidth(
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CreateVacationDay(
                                  edit: true,
                                  vacation: vacations[index],
                                  onVacationEdit: () {
                                    setState(() {
                                      _vacationsRequest = VacationServices.getVacations();
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await VacationServices.deleteVacation(vacations[index].id);
                              setState(() {
                                _vacationsRequest = VacationServices.getVacations();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => 16.verticalSpace,
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Format: February 1st
    return '${_getMonth(date)} ${date.day}${_getDaySuffix(date.day)}';
  }

  String _getMonth(DateTime date) {
    return ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][date.month - 1];
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
