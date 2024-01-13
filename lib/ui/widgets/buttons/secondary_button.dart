import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double? height;
  final bool thin;
  final bool shrinkWrap;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.shrinkWrap = false,
    this.thin = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading
            ? null
            : () {
                HapticFeedback.vibrate();
                onPressed!();
              },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
          side: BorderSide(
            color: AppColors.accent,
            width: 2.w,
          ),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: thin ? 0 : 13.h, horizontal: shrinkWrap ? 20.w : 0),
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
                    style: TextStyles.button.apply(color: AppColors.accent),
                  ),
                ],
              ),
      ),
    );
  }
}
