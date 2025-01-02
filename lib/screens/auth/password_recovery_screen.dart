import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/password_recovery_controller.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  static const String routeName = "/passwordRecoveryScreen";
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final controller = Get.put(PasswordRecoveryController());
  bool _obscurePassword = true;

  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  void initState() {
    super.initState();
    // controller.fetchData();
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordRecoveryController>(builder: (controller) {
      return Scaffold(
        backgroundColor: CustomColors.getBodyColor2(),
        body: Stack(
          children: [
            Positioned(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      "assets/background.png",
                      fit: BoxFit.cover,
                      height: 120,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(top: 50.h),
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                hoverColor: CustomColors.primaryColor,
                                padding: EdgeInsets.all(0.w),
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  CupertinoIcons.back,
                                  color: Colors.white,
                                  size: 28.sp,
                                ),
                              ),
                              Text(
                                "Recover Password",
                                style: GoogleFonts.jost(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  CupertinoIcons.settings,
                                  color: Colors.transparent,
                                  size: 24.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100.h),
            Container(
              margin: EdgeInsets.only(top: 100.h),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    Get.isDarkMode ? 'assets/overlay_dark.png' : 'assets/overlay.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                  ),
                  SingleChildScrollView(
                    child: Stepper(
                      currentStep: controller.currentStep,
                      onStepTapped: (step) {},
                      onStepContinue: () {
                        if (controller.currentStep == 0) {
                          // If on the first step, send validation code
                          controller.sendValidationCode();
                        } else if (controller.currentStep == 1) {
                          // If on the second step, reset the password
                          controller.matchValidationCode();
                        } else if (controller.currentStep == 2) {
                          // If on the second step, reset the password
                          controller.resetPassword();
                        }
                      },
                      onStepCancel: () {
                        if (controller.currentStep > 0) {
                          controller.previousStep();
                        }
                      },
                      steps: [
                        Step(
                          title: Text(
                            languageData['Step 1'] ?? 'Step 1',
                            style: GoogleFonts.jost(
                              color: CustomColors.getTitleColor(),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          state: controller.currentStep == 0
                              ? StepState.editing
                              : (controller.currentStep > 0 ? StepState.complete : StepState.indexed),
                          isActive: controller.currentStep == 0,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                languageData['Enter your email address:'] ?? 'Enter your email address:',
                              ),
                              SizedBox(height: 16.h),
                              TextFormField(
                                controller: controller.emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return languageData['Please enter your email'] ?? 'Please enter your email';
                                  }
                                  // Use a regular expression to check if the email is valid
                                  bool isValidEmail = RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                                  ).hasMatch(value);

                                  if (!isValidEmail) {
                                    return languageData['Please enter a valid email address'] ??
                                        'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                style: GoogleFonts.getFont(
                                  'Jost',
                                  textStyle: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  hintText: languageData['Email'] ?? 'Email',
                                  contentPadding: EdgeInsets.all(14.w),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                      width: 1.w,
                                    ),
                                  ),
                                  errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                                  filled: true,
                                  fillColor: CustomColors.getInputColor2(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Step(
                          title: Text(
                            languageData['Step 2'] ?? 'Step 2',
                            style: GoogleFonts.jost(
                              color: CustomColors.getTitleColor(),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          state: controller.currentStep == 1
                              ? StepState.editing
                              : (controller.currentStep > 1 ? StepState.complete : StepState.indexed),
                          isActive: controller.currentStep == 1,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                languageData['Enter the validation code sent to your email:'] ??
                                    'Enter the validation code sent to your email:',
                              ),
                              SizedBox(height: 16.h),
                              TextFormField(
                                controller: controller.validationCodeController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return languageData['Please enter your code'] ?? 'Please enter your code';
                                  }
                                  return null;
                                },
                                style: GoogleFonts.getFont(
                                  'Jost',
                                  textStyle: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  hintText: languageData['Validation Code'] ?? 'Validation Code',
                                  contentPadding: EdgeInsets.all(14.w),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                      width: 1.w,
                                    ),
                                  ),
                                  errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                                  filled: true,
                                  fillColor: CustomColors.getInputColor2(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Step(
                          title: Text(
                            languageData['Step 3'] ?? 'Step 3',
                            style: GoogleFonts.jost(
                              color: CustomColors.getTitleColor(),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          state: controller.currentStep == 2
                              ? StepState.editing
                              : (controller.currentStep > 2 ? StepState.complete : StepState.indexed),
                          isActive: controller.currentStep == 2,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                languageData['Set your new password:'] ?? 'Set your new password:',
                              ),
                              SizedBox(height: 16.h),
                              TextFormField(
                                controller: controller.passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return languageData['Please enter your password'] ?? 'Please enter your password';
                                  }
                                  // if (value.length < 8) {
                                  //   return 'Password must be at least 8 characters long';
                                  // }
                                  // if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                  //   return 'Password must contain at least one uppercase letter';
                                  // }
                                  // if (!RegExp(r'[a-z]').hasMatch(value)) {
                                  //   return 'Password must contain at least one lowercase letter';
                                  // }
                                  // if (!RegExp(r'[0-9]').hasMatch(value)) {
                                  //   return 'Password must contain at least one digit';
                                  // }
                                  // if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                                  //   return 'Password must contain at least one special character';
                                  // }
                                  return null;
                                },
                                style: GoogleFonts.getFont(
                                  'Jost',
                                  textStyle: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  hintText: languageData["Password"] ?? "Password",
                                  contentPadding: EdgeInsets.all(14.w),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                                      color: Colors.grey,
                                      size: 20.sp,
                                    ),
                                    onPressed: _togglePasswordVisibility,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                      width: 1.w,
                                    ),
                                  ),
                                  errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                                  filled: true,
                                  fillColor: CustomColors.getInputColor2(),
                                ),
                                obscureText: _obscurePassword,
                              ),
                              SizedBox(height: 16.h),
                              TextFormField(
                                controller: controller.confirmPasswordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return languageData['Please confirm your password'] ??
                                        'Please confirm your password';
                                  }
                                  if (value != controller.passwordController.text) {
                                    return languageData['Passwords do not match'] ?? 'Passwords do not match';
                                  }
                                  return null;
                                },
                                style: GoogleFonts.getFont(
                                  'Jost',
                                  textStyle: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  hintText: languageData["Confirm Password"] ?? "Confirm Password",
                                  contentPadding: EdgeInsets.all(14.w),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                                      color: Colors.grey,
                                      size: 20.sp,
                                    ),
                                    onPressed: _togglePasswordVisibility,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: CustomColors.primaryColor,
                                      width: 1.w,
                                    ),
                                  ),
                                  errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                                  filled: true,
                                  fillColor: CustomColors.getInputColor2(),
                                ),
                                obscureText: _obscurePassword,
                              ),
                            ],
                          ),
                        ),
                      ],
                      controlsBuilder: (context, actions) {
                        return Padding(
                          padding: EdgeInsets.only(top: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              if (controller.currentStep >= 0)
                                TextButton(
                                  onPressed: actions.onStepCancel,
                                  child: Text(
                                    languageData['Previous'] ?? 'Previous',
                                    style: GoogleFonts.getFont(
                                      'Jost',
                                      textStyle: TextStyle(fontSize: 0.sp, color: CustomColors.getTextColor()),
                                    ),
                                  ),
                                ),
                              ElevatedButton(
                                onPressed: actions.onStepContinue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  textStyle: GoogleFonts.getFont(
                                    'Jost',
                                    textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      color: CustomColors.primaryColor,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                                  ),
                                ),
                                child: !controller.isLoading
                                    ? Text(
                                        languageData["Continue"] ?? "Continue",
                                      )
                                    : Center(
                                        child: SizedBox(
                                          width: 23.w,
                                          height: 23.h,
                                          child: const CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(CustomColors.whiteColor),
                                            strokeWidth: 2.0,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
