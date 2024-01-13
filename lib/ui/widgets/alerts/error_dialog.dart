import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  const ErrorDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      content: Row(
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
          ),
          10.horizontalSpace,
          Expanded(child: Text('Error${message != null ? ': $message' : ''}')),
        ],
      ),
    );
  }
}
