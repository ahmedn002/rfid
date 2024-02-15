import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rfid_system/services/response_wrapper.dart';

import '../model/entities/vacation.dart';

class VacationServices {
  static Future<FirebaseResponseWrapper<List<Vacation>>> getVacations() async {
    return await FirebaseFirestore.instance.collection('Vacations').get().then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      final List<Map> vacationJsons = querySnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      final List<Vacation> vacations = vacationJsons.map<Vacation>((Map vacationJson) => Vacation.fromJson(vacationJson as Map<String, dynamic>)).toList();

      return FirebaseResponseWrapper<List<Vacation>>(
        data: vacations,
        hasError: false,
        message: 'Vacations fetched successfully.',
      );
    });
  }

  static Future<FirebaseResponseWrapper<bool>> createVacation(DateTime date) async {
    return await FirebaseFirestore.instance.collection('Vacations').add({
      'date': date,
    }).then((DocumentReference<Map<String, dynamic>> docRef) {
      return FirebaseResponseWrapper<bool>(
        data: true,
        hasError: false,
        message: 'Vacation created successfully.',
      );
    });
  }

  static Future<FirebaseResponseWrapper<bool>> deleteVacation(String id) async {
    return await FirebaseFirestore.instance.collection('Vacations').doc(id).delete().then((_) {
      return FirebaseResponseWrapper<bool>(
        data: true,
        hasError: false,
        message: 'Vacation deleted successfully.',
      );
    });
  }

  static Future<FirebaseResponseWrapper<bool>> updateVacation(String id, DateTime date) async {
    return await FirebaseFirestore.instance.collection('Vacations').doc(id).update({
      'date': date,
    }).then((_) {
      return FirebaseResponseWrapper<bool>(
        data: true,
        hasError: false,
        message: 'Vacation updated successfully.',
      );
    });
  }
}
