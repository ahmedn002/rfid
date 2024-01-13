// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';

AppBar RFIDAppBar({
  Widget? trailing,
  bool? enableNavigation,
  bool? automaticallyImplyLeading,
}) {
  return AppBar(
    backgroundColor: AppColors.background,
    elevation: 0,
    automaticallyImplyLeading: automaticallyImplyLeading ?? true,
    leading: enableNavigation == true
        ? const Icon(
            Icons.menu_rounded,
            color: AppColors.accent,
          )
        : null,
    title: SvgPicture.asset(
      'assets/logo/RFID_Logo.svg',
      width: 0.3.sw,
    ),
    centerTitle: true,
    // drop down menu button containing logout
    actions: [if (trailing != null) trailing],
  );
}

AppBar TextAppBar(String title) {
  return AppBar(
    backgroundColor: AppColors.background,
    elevation: 0,
    iconTheme: const IconThemeData(color: AppColors.textPrimary),
    title: Text(
      title,
      style: TextStyles.appBarTitle,
    ),
    centerTitle: true,
  );
}
