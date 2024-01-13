import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';

class MainButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;
  final bool shrinkWrap;
  const MainButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                HapticFeedback.vibrate();
                onPressed!();
              },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: AppColors.accent,
          padding: EdgeInsets.symmetric(vertical: 13.h),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.h,
                height: 20.h,
                child: const CircularProgressIndicator(
                  color: AppColors.background,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) icon!,
                  if (icon != null) 10.horizontalSpace,
                  Text(
                    text,
                    style: TextStyles.button,
                  ),
                ],
              ),
      ),
    );
  }
}
