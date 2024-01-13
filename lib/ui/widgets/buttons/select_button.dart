import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';

import '../../constants/colors.dart';

class SelectButton extends StatelessWidget {
  final String text;
  final Widget? child;
  final bool isSelected;
  final void Function() onTap;
  final double? width;
  const SelectButton({
    super.key,
    this.text = '',
    this.child,
    required this.isSelected,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.vibrate();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOutExpo,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        constraints: BoxConstraints(
          minWidth: 0.2.sw,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          color: isSelected ? AppColors.lightAccent : AppColors.background,
          border: Border.all(
            color: isSelected ? AppColors.lightAccent : AppColors.textPrimary,
            width: 1.3.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle_outline_rounded : Icons.circle_outlined,
              color: isSelected ? AppColors.accent : AppColors.textPrimary,
              size: 20.r,
            ),
            5.horizontalSpace,
            child != null
                ? Expanded(child: child!)
                : Text(
                    '$text ',
                    style: TextStyles.button.copyWith(
                      color: isSelected ? AppColors.accent : AppColors.textPrimary,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
