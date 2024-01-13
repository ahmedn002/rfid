import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DayTimeSelectButton extends StatefulWidget {
  final String day;
  final Function(TimeOfDay?) onTimeChanged;
  const DayTimeSelectButton({super.key, required this.day, required this.onTimeChanged});

  @override
  State<DayTimeSelectButton> createState() => _DayTimeSelectButtonState();
}

class _DayTimeSelectButtonState extends State<DayTimeSelectButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.3.sw,
      child: ElevatedButton(
        onPressed: () async {
          final TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          widget.onTimeChanged(time);
        },
        child: Text(widget.day),
      ),
    );
  }
}
