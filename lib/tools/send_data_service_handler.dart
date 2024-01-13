import 'package:flutter/material.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/ui/widgets/alerts/error_dialog.dart';
import 'package:rfid_system/ui/widgets/alerts/sucess_dialog.dart';

import '../ui/widgets/alerts/loading_dialog.dart';

class RequestHandler {
  static Future<T?> handleRequest<T>({
    required BuildContext context,
    required Future<FirebaseResponseWrapper<T>> Function() service,
    Function()? onSuccess,
    Function()? onError,
    bool enableSuccessDialog = true,
    bool retry = false,
    int retryThreshold = 3,
  }) async {
    int retryCount = 0;
    bool hasError = false;
    String? errorMessage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingDialog(),
    );

    do {
      try {
        final FirebaseResponseWrapper<T> result = await service();
        if (!result.hasError) {
          if (context.mounted) {
            Navigator.pop(context);
            if (enableSuccessDialog) {
              showDialog(
                context: context,
                builder: (_) => const SuccessDialog(),
              );
            }
          }
          if (onSuccess != null) {
            onSuccess();
          }
          return result.data;
        } else {
          hasError = true;
          errorMessage = result.message;
        }

        break;
      } catch (error) {
        hasError = true;
      }
      retryCount++;
    } while (retry && retryCount < retryThreshold);

    if (hasError) {
      if (onError != null) {
        onError();
      }
      if (context.mounted) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(message: errorMessage),
        );
      }
    }

    return null;
  }
}
