import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/model/ui/password_reset_request.dart';
import 'package:rfid_system/services/reset_password_services.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/tools/send_data_service_handler.dart';
import 'package:rfid_system/ui/widgets/api%20widgets/RequestWidget.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';
import '../../../widgets/app_bar.dart';

class PasswordResetRequestsScreen extends StatefulWidget {
  const PasswordResetRequestsScreen({super.key});

  @override
  State<PasswordResetRequestsScreen> createState() => _PasswordResetRequestsScreenState();
}

class _PasswordResetRequestsScreenState extends State<PasswordResetRequestsScreen> {
  Future<FirebaseResponseWrapper<List<PasswordResetRequest>>> _getPasswordResetRequests = ResetPasswordServices.getPasswordResetRequests();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TextAppBar('Reset Password Requests'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: RequestWidget(
          request: () => _getPasswordResetRequests,
          successWidgetBuilder: (List<PasswordResetRequest> passwordResetRequests) {
            return ListView.separated(
              itemCount: passwordResetRequests.length,
              itemBuilder: (context, index) {
                final PasswordResetRequest passwordResetRequest = passwordResetRequests[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.foregroundOne,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(passwordResetRequest.username),
                        4.horizontalSpace,
                        Container(
                          padding: EdgeInsets.all(5.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: AppColors.success.withOpacity(0.25),
                          ),
                          child: Text(
                            passwordResetRequest.collection.substring(0, passwordResetRequest.collection.length - 1),
                            style: TextStyles.bodySmall.apply(
                              color: AppColors.success,
                              fontWeightDelta: 2,
                            ),
                          ),
                        )
                      ],
                    ),
                    subtitle: Text('New Password: ${passwordResetRequest.newPassword}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_rounded),
                          onPressed: () => _accept(passwordResetRequest),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => _reject(passwordResetRequest),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => 8.verticalSpace,
            );
          },
        ),
      ),
    );
  }

  void _accept(PasswordResetRequest passwordResetRequest) async {
    RequestHandler.handleRequest(
      context: context,
      service: () => ResetPasswordServices.resetPassword(passwordResetRequest),
      onSuccess: () {
        setState(() {
          _getPasswordResetRequests = ResetPasswordServices.getPasswordResetRequests();
        });
      },
    );
  }

  void _reject(PasswordResetRequest passwordResetRequest) async {
    RequestHandler.handleRequest(
      context: context,
      service: () => ResetPasswordServices.deletePasswordResetRequest(passwordResetRequest.id),
      onSuccess: () {
        setState(() {
          _getPasswordResetRequests = ResetPasswordServices.getPasswordResetRequests();
        });
      },
    );
  }
}
