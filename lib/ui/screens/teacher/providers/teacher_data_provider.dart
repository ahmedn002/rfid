import 'package:flutter/material.dart';
import 'package:rfid_system/model/ui/teacher_dashboard_model.dart';

class TeacherDataProvider extends ChangeNotifier {
  late TeacherDashboardModel teacherDashboardModel;

  void setTeacherDashboardModel(TeacherDashboardModel model) {
    teacherDashboardModel = model;
    notifyListeners();
  }
}
