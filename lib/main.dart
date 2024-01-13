import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rfid_system/services/firebase_options.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/providers/auth_provider.dart';
import 'package:rfid_system/ui/screens/auth/signin/signin_screen.dart';
import 'package:rfid_system/ui/screens/auth/signup/providers/signup_provider.dart';
import 'package:rfid_system/ui/screens/student/provider/student_navigation_provider.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_data_provider.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_navigation_provider.dart';
import 'package:rfid_system/ui/screens/teacher/providers/teacher_request_provider.dart';
import 'package:rfid_system/ui/utilities/misc_utilities.dart';

Future<void> main() async {
  // Changing status bar color
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.accent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SignUpProvider()),
          ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
          ChangeNotifierProvider(create: (_) => TeacherNavigationProvider()),
          ChangeNotifierProvider(create: (_) => TeacherRequestProvider()),
          ChangeNotifierProvider(create: (_) => TeacherDataProvider()),
          ChangeNotifierProvider(create: (_) => StudentNavigationProvider()),
        ],
        child: SafeArea(
          child: MaterialApp(
            title: 'RFID System',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: MiscUtilities.getMaterialColor(AppColors.accent),
              scaffoldBackgroundColor: AppColors.background,
              fontFamily: 'Outfit|',
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: AppColors.textPrimary,
                    displayColor: AppColors.textPrimary,
                    fontFamily: 'Outfit',
                  ),
              appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: AppColors.accent),
              ),
              iconTheme: const IconThemeData(color: AppColors.accent),
            ),
            home: const SignInScreen(),
          ),
        ),
      ),
    );
  }
}
