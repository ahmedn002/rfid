import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/ui/constants/colors.dart';

class TextStyles {
  static TextStyle appBarTitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 23.sp,
    fontWeight: FontWeight.w800,
  );

  static TextStyle title = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle body = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodySecondary = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodySmall = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle button = TextStyle(
    color: AppColors.background,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );
}
