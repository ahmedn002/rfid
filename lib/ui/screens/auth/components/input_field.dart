import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/ui/constants/colors.dart';

import '../../../constants/text_styles.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final bool obscureText;
  final bool enabled;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function()? onTap;

  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.enabled = true,
    this.onChanged,
    this.icon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onTap,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool obscureText = false;
  Widget? unObscureIcon;

  @override
  void initState() {
    obscureText = widget.obscureText;
    if (widget.obscureText) {
      unObscureIcon = IconButton(
        onPressed: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
        icon: Icon(
          obscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded,
          color: AppColors.accent,
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: TextFormField(
        enabled: widget.enabled,
        controller: widget.controller,
        obscureText: obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: TextInputAction.next,
        validator: widget.validator,
        onChanged: widget.onChanged,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: AppColors.accent,
                )
              : null,
          suffixIcon: widget.suffixIcon ??
              (widget.obscureText
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                        HapticFeedback.vibrate();
                      },
                      splashRadius: 15.r,
                      splashColor: AppColors.accent.withOpacity(0.2),
                      icon: Icon(
                        obscureText ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                        color: AppColors.accent,
                      ),
                    )
                  : null),
          contentPadding: EdgeInsets.only(left: 10.w),
          hintText: widget.hintText,
          hintStyle: TextStyles.bodySecondary.apply(fontWeightDelta: 2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
        ),
      ),
    );
  }
}
