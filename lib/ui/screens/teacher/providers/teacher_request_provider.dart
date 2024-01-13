import 'package:flutter/cupertino.dart';
import 'package:rfid_system/model/ui/teacher_dashboard_model.dart';
import 'package:rfid_system/services/response_wrapper.dart';

class TeacherRequestProvider extends ChangeNotifier {
  late Future<FirebaseResponseWrapper<TeacherDashboardModel>> getTeacherDashboardModel;

  void setTeacherDashboardModel(Future<FirebaseResponseWrapper<TeacherDashboardModel>> model) {
    getTeacherDashboardModel = model;
    notifyListeners();
  }
}
