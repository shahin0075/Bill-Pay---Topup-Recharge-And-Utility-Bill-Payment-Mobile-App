import 'package:bill_payment/controller/auth_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/screens/auth/password_recovery_screen.dart';
import 'package:bill_payment/screens/auth/signup_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = "/signInScreen";
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String initialCountry = 'BD';

  final authController = Get.put(AuthController());

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
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        backgroundColor: CustomColors.getBodyColor2(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              Get.isDarkMode ? 'assets/overlay_dark.png' : 'assets/overlay.png',
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          languageData["Welcome Back"] ?? "Welcome Back",
                          style: TextStyle(
                            color: CustomColors.getTitleColor(),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          languageData["Hello there! Sign in to continue."] ?? "Hello there! Sign in to continue.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: CustomColors.getTextColor(),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return languageData['Please enter your username'] ?? 'Please enter your username';
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
                            hintText: languageData['Username'] ?? 'Username',
                            contentPadding: EdgeInsets.all(14.w),
                            prefixIcon: Icon(
                              CupertinoIcons.mail,
                              size: 18.w,
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
                        ),
                        SizedBox(height: 16.h),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return languageData['Please enter your password'] ?? 'Please enter your password';
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
                            hintText: languageData["Password"] ?? "Password",
                            contentPadding: EdgeInsets.all(14.w),
                            prefixIcon: Icon(
                              CupertinoIcons.lock,
                              size: 18.w,
                            ),
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
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              // Form is valid, perform desired action
                              authController.signIn(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                            width: 300.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: CustomColors.primaryColor,
                            ),
                            child: !authController.isLoading
                                ? Text(
                                    languageData["Sign In"] ?? "Sign In",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.jost(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                    ),
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
                        ),
                        SizedBox(height: 16.h),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(PasswordRecoveryScreen.routeName);
                          },
                          child: Text(
                            languageData["Forgot Password?"] ?? "Forgot Password?",
                            style: GoogleFonts.jost(
                              color: CustomColors.primaryColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(SignUpScreen.routeName);
                          },
                          child: Text(
                            languageData["Don't have an account? Sign up"] ?? "Don't have an account? Sign up",
                            style: GoogleFonts.jost(
                              color: CustomColors.getTitleColor(),
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
