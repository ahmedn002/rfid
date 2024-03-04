import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';

class DropDownMenu extends StatefulWidget {
  Map<dynamic, String> items;
  final void Function(Object? value) onChanged;
  final String hint;
  final List<DropdownMenuItem>? dropDownMenuItems;
  final Object? value;
  final IconData? icon;
  final bool loadingData;
  final String loadingText;
  final Key? assignKey;
  DropDownMenu(
      {super.key,
      required this.items,
      required this.onChanged,
      required this.hint,
      this.dropDownMenuItems,
      this.value,
      this.icon,
      this.loadingData = false,
      this.assignKey,
      this.loadingText = 'Loading...'});

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<dynamic>(
      key: widget.assignKey,
      items: widget.dropDownMenuItems ??
          widget.items.entries.map((entry) {
            return DropdownMenuItem(
              value: entry.key,
              child: Text(
                entry.value,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
      selectedItemBuilder: (context) {
        return widget.loadingData
            ? []
            : widget.items.entries.map(
                (entry) {
                  return SizedBox(
                    width: 0.63.sw,
                    child: Text(
                      entry.value,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.body,
                    ),
                  );
                },
              ).toList();
      },
      value: widget.value,
      hint: Text(
        widget.loadingData ? widget.loadingText : widget.hint,
        style: TextStyles.bodySecondary.apply(fontWeightDelta: 2),
      ),
      iconSize: 0,
      onChanged: widget.onChanged,
      style: TextStyles.body,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        contentPadding: EdgeInsets.zero,
        hintStyle: TextStyles.bodySecondary.apply(fontWeightDelta: 2),
        prefixIcon: Icon(
          widget.icon,
          color: AppColors.accent,
        ),
        suffixIconConstraints: BoxConstraints(
          minWidth: 15.w,
          minHeight: 15.w,
        ),
        suffixIcon: widget.loadingData
            ? Container(
                margin: EdgeInsets.only(right: 15.w),
                width: 15.w,
                height: 15.w,
                child: const CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: const Icon(
                  Icons.arrow_drop_down_circle_rounded,
                  color: AppColors.accent,
                ),
              ),
      ),
    );
  }
}
