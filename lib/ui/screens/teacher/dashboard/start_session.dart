import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rfid_system/model/entities/session.dart';
import 'package:rfid_system/services/response_wrapper.dart';
import 'package:rfid_system/services/session_services.dart';
import 'package:rfid_system/services/teacher_services.dart';
import 'package:rfid_system/tools/send_data_service_handler.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/constants/text_styles.dart';
import 'package:rfid_system/ui/providers/auth_provider.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_request_provider.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';

import '../concluded session/concluded_session.dart';

class StartSessionScreen extends StatefulWidget {
  final Session session;
  const StartSessionScreen({super.key, required this.session});

  @override
  State<StartSessionScreen> createState() => _StartSessionScreenState();
}

class _StartSessionScreenState extends State<StartSessionScreen> {
  late final Stream<FirebaseResponseWrapper<Session?>> _sessionStream;
  bool _sessionStarted = false;

  @override
  void initState() {
    _sessionStream = SessionServices.listenToSession(widget.session.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RFIDAppBar(automaticallyImplyLeading: !_sessionStarted),
      body: WillPopScope(
        onWillPop: () async => !_sessionStarted,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: StreamBuilder<FirebaseResponseWrapper<Session?>>(
            stream: _sessionStream,
            builder: (context, AsyncSnapshot<FirebaseResponseWrapper<Session?>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final Session? session = snapshot.data!.data;
                if (snapshot.hasData && session != null) {
                  if (session.state == false) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (_sessionStarted) {
                        RequestHandler.handleRequest(
                          context: context,
                          service: () => SessionServices.concludeSession(widget.session.id),
                          enableSuccessDialog: false,
                          onSuccess: () {
                            widget.session.concluded = true;
                            context.read<TeacherRequestProvider>().setTeacherDashboardModel(
                                  TeacherServices.getTeacherDashboardModel(
                                    context.read<AuthenticationProvider>().teacher.id,
                                  ),
                                );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ConcludedSessionScreen(session: widget.session)),
                            );
                          },
                        );
                      }
                    });
                    return WaitingForSessionStartScreen(widget: widget);
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (!_sessionStarted) {
                        setState(() {
                          _sessionStarted = true;
                        });
                      }
                    });
                    return WaitingForSessionEndScreen(widget: widget);
                  }
                } else {
                  return const Center(
                    child: Text('Session Not Found'),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

class WaitingForSessionEndScreen extends StatelessWidget {
  const WaitingForSessionEndScreen({
    super.key,
    required this.widget,
  });

  final StartSessionScreen widget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 115.r,
              ),
              20.horizontalSpace,
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: AppColors.lightAccent,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: FittedBox(child: Text(widget.session.id, style: TextStyles.title.apply(fontSizeFactor: 3, color: AppColors.accent))),
                ),
              ),
            ],
          ),
          20.verticalSpace,
          Text('Session started successfully!', style: TextStyles.title),
          10.verticalSpace,
          Text('You can now start scanning tags.', style: TextStyles.body),
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Waiting for you to end session...', style: TextStyles.bodySecondary),
              10.horizontalSpace,
              SizedBox(
                width: 20.r,
                height: 20.r,
                child: const CircularProgressIndicator(),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class WaitingForSessionStartScreen extends StatelessWidget {
  const WaitingForSessionStartScreen({
    super.key,
    required this.widget,
  });

  final StartSessionScreen widget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(child: Text('Enter session code on your system keypad to start.', style: TextStyles.title)),
              Icon(Icons.keyboard_alt_rounded, size: 60.r),
            ],
          ),
          40.verticalSpace,
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.lightAccent,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Text(widget.session.id, style: TextStyles.title.apply(fontSizeFactor: 3.5, color: AppColors.accent)),
          ),
          40.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Waiting for your input...', style: TextStyles.bodySecondary),
              10.horizontalSpace,
              SizedBox(
                width: 20.r,
                height: 20.r,
                child: const CircularProgressIndicator(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
