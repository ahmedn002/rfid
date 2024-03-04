import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rfid_system/model/ui/password_reset_request.dart';
import 'package:rfid_system/services/response_wrapper.dart';

class ResetPasswordServices {
  static Future<FirebaseResponseWrapper<bool>> addResetPasswordRequest(String username, String password, String collection) async {
    bool hasError = false;

    // Getting Id from username
    String id = '';
    try {
      await FirebaseFirestore.instance
          .collection(
            collection,
          )
          .where('username', isEqualTo: username)
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        id = querySnapshot.docs.first.id;
      });
    } catch (e) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: true,
        message: 'Username not found',
      );
    }

    final Map<String, dynamic> data = {
      'userId': id,
      'username': username,
      'password': password,
      'type': collection,
    };

    try {
      await FirebaseFirestore.instance.collection('Password_Reset_Requests').add(data);
    } catch (e) {
      hasError = true;
    }

    if (hasError) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: true,
        message: 'Error resetting password',
      );
    } else {
      return FirebaseResponseWrapper(
        data: true,
        hasError: false,
        message: 'Requested reset successfully',
      );
    }
  }

  static Future<FirebaseResponseWrapper<List<PasswordResetRequest>>> getPasswordResetRequests() async {
    bool hasError = false;
    List<PasswordResetRequest> passwordResetRequests = [];

    try {
      await FirebaseFirestore.instance.collection('Password_Reset_Requests').get().then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        passwordResetRequests = querySnapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
          return PasswordResetRequest.fromJson({
            'id': doc.id,
            ...doc.data(),
          });
        }).toList();
      });
    } catch (e) {
      hasError = true;
    }

    if (hasError) {
      return FirebaseResponseWrapper(
        data: [],
        hasError: true,
        message: 'Error fetching password reset requests',
      );
    } else {
      return FirebaseResponseWrapper(
        data: passwordResetRequests,
        hasError: false,
        message: 'Password reset requests fetched successfully',
      );
    }
  }

  static Future<FirebaseResponseWrapper<bool>> deletePasswordResetRequest(String id) async {
    bool hasError = false;

    try {
      await FirebaseFirestore.instance.collection('Password_Reset_Requests').doc(id).delete();
    } catch (e) {
      hasError = true;
    }

    if (hasError) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: true,
        message: 'Error deleting password reset request',
      );
    } else {
      return FirebaseResponseWrapper(
        data: true,
        hasError: false,
        message: 'Password reset request deleted successfully',
      );
    }
  }

  static Future<FirebaseResponseWrapper<bool>> resetPassword(PasswordResetRequest request) async {
    final String collection = request.collection;
    final String docId = request.userId;
    final String newPassword = request.newPassword;

    bool hasError = false;

    try {
      await FirebaseFirestore.instance.collection(collection).doc(docId).update({
        'password': newPassword,
      });
    } catch (e) {
      hasError = true;
    }

    if (hasError) {
      return FirebaseResponseWrapper(
        data: false,
        hasError: true,
        message: 'Error resetting password',
      );
    } else {
      await deletePasswordResetRequest(request.id);
      return FirebaseResponseWrapper(
        data: true,
        hasError: false,
        message: 'Password reset successfully',
      );
    }
  }
}
