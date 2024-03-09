import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rfid_system/model/entities/student.dart';
import 'package:rfid_system/model/entities/teacher.dart';
import 'package:rfid_system/services/reset_password_services.dart';
import 'package:rfid_system/services/student_services.dart';
import 'package:rfid_system/tools/send_data_service_handler.dart';
import 'package:rfid_system/ui/constants/colors.dart';
import 'package:rfid_system/ui/providers/auth_provider.dart';
import 'package:rfid_system/ui/screens/teacher/teacher_navigation_wrapper.dart';
import 'package:rfid_system/ui/widgets/app_bar.dart';
import 'package:rfid_system/ui/widgets/buttons/select_button.dart';

import '../../../../services/teacher_services.dart';
import '../../../constants/text_styles.dart';
import '../../../widgets/buttons/main_button.dart';
import '../../admin/admin_dashboard.dart';
import '../../student/student_navigation_wrapper.dart';
import '../components/input_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
// Form key
  final _signInFormKey = GlobalKey<FormState>();
  final _resetPasswordFormKey = GlobalKey<FormState>();

  // Controllers

  // Sign In
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Reset Password

  final TextEditingController _resetPasswordUsernameController = TextEditingController();
  final TextEditingController _resetPasswordController = TextEditingController();
  final TextEditingController _resetPasswordConfirmController = TextEditingController();

  // Focus nodes
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _signInIsStudent = true;
  bool _resetIsStudent = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RFIDAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              'Welcome, please choose your role and enter your credentials.',
                              style: TextStyles.title,
                              textAlign: TextAlign.center,
                            ),
                            20.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SelectButton(
                                  text: 'Student',
                                  isSelected: _signInIsStudent,
                                  onTap: () {
                                    setState(() {
                                      _signInIsStudent = true;
                                    });
                                  },
                                ),
                                SelectButton(
                                  text: 'Instructor',
                                  isSelected: !_signInIsStudent,
                                  onTap: () {
                                    setState(() {
                                      _signInIsStudent = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                            30.verticalSpace,
                            Form(
                              key: _signInFormKey,
                              child: Column(
                                children: [
                                  InputField(
                                    controller: _usernameController,
                                    hintText: 'Username',
                                    icon: Icons.person_rounded,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your username';
                                      }
                                      return null;
                                    },
                                  ),
                                  20.verticalSpace,
                                  InputField(
                                    controller: _passwordController,
                                    hintText: 'Password',
                                    icon: Icons.lock_rounded,
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            10.verticalSpace,
                            TextButton(
                              onPressed: _showResetPasswordDialog,
                              child: Text(
                                'Forgot password?',
                                style: TextStyles.body.apply(color: AppColors.accent, fontWeightDelta: 2),
                              ),
                            ),
                            10.verticalSpace,
                            MainButton(
                              text: 'Sign In',
                              icon: const Icon(Icons.login_rounded),
                              onPressed: () {
                                if (_signInFormKey.currentState!.validate()) {
                                  _signIn();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.nfc_rounded,
                          size: 100.r,
                          color: AppColors.accent,
                        ),
                        SizedBox(
                          height: 100.r,
                          child: VerticalDivider(
                            width: 20.w,
                            color: AppColors.textPrimary,
                            thickness: 2.w,
                          ),
                        ),
                        SizedBox(
                          width: 0.5.sw,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Easy attendance tracking using ',
                                  style: TextStyles.title.copyWith(color: AppColors.textPrimary, fontFamily: 'Outfit'),
                                ),
                                TextSpan(
                                  text: 'RFID',
                                  style: TextStyles.title.copyWith(color: AppColors.accent, fontFamily: 'Outfit'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    if (_signInFormKey.currentState!.validate()) {
      if (_usernameController.text == 'Admin' && _passwordController.text == '123456') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AdminDashboard(),
          ),
        );
      } else if (_signInIsStudent) {
        final Student? student = await RequestHandler.handleRequest<Student?>(
          context: context,
          enableSuccessDialog: false,
          service: () => StudentServices.login(_usernameController.text, _passwordController.text),
          onSuccess: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const StudentNavigationWrapper(),
              ),
            );
          },
        );
        if (student != null && context.mounted) {
          Provider.of<AuthenticationProvider>(context, listen: false).student = student;
        }
      } else {
        final Teacher? teacher = await RequestHandler.handleRequest<Teacher?>(
          context: context,
          enableSuccessDialog: false,
          service: () => TeacherServices.login(_usernameController.text, _passwordController.text),
          onSuccess: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const TeacherNavigationWrapper(),
              ),
            );
          },
        );
        if (teacher != null && context.mounted) {
          Provider.of<AuthenticationProvider>(context, listen: false).teacher = teacher;
        }
      }
    }
  }

  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          'Reset Password',
          style: TextStyles.title,
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SelectButton(
                      text: 'Student',
                      isSelected: _resetIsStudent,
                      onTap: () {
                        setState(() {
                          _resetIsStudent = true;
                        });
                      },
                    ),
                    SelectButton(
                      text: 'Instructor',
                      isSelected: !_resetIsStudent,
                      onTap: () {
                        setState(() {
                          _resetIsStudent = false;
                        });
                      },
                    ),
                  ],
                ),
                20.verticalSpace,
                Form(
                  key: _resetPasswordFormKey,
                  child: Column(
                    children: [
                      InputField(
                        controller: _resetPasswordUsernameController,
                        hintText: 'Username',
                        icon: Icons.person_rounded,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      20.verticalSpace,
                      InputField(
                        controller: _resetPasswordController,
                        hintText: 'New Password',
                        icon: Icons.lock_rounded,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your new password';
                          }
                          return null;
                        },
                      ),
                      20.verticalSpace,
                      InputField(
                        controller: _resetPasswordConfirmController,
                        hintText: 'Confirm New Password',
                        icon: Icons.lock_rounded,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your new password';
                          }
                          if (value != _resetPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                20.verticalSpace,
                MainButton(
                  text: 'Request Reset',
                  onPressed: () {
                    if (_resetPasswordFormKey.currentState!.validate()) {
                      _resetPassword();
                    }
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }

  void _resetPassword() {
    RequestHandler.handleRequest<bool>(
      context: context,
      service: () => ResetPasswordServices.addResetPasswordRequest(
        _resetPasswordUsernameController.text,
        _resetPasswordController.text,
        _resetIsStudent ? 'Students' : 'Teachers',
      ),
      onSuccess: () {
        _resetPasswordUsernameController.clear();
        _resetPasswordController.clear();
        _resetPasswordConfirmController.clear();
      },
    );
  }
}
