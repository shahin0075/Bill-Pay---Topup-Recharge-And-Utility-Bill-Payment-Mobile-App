import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/auth/signup_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routeName = "/welcomeScreen";
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              const Spacer(),
              const Spacer(),
              Image.asset(
                "assets/welcome.png",
                width: 300.w,
                height: 300.h,
              ),
              // const Spacer(),
              SizedBox(height: 16.h),
              Text(
                "Welcome",
                style: TextStyle(
                  color: CustomColors.getTitleColor(),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Manage your payment seamlessly & intuitively",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomColors.getTextColor(),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
                  width: 300.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CustomColors.primaryColor,
                  ),
                  child: Text(
                    'Create an account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.jost(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                },
                child: Text(
                  "Already have an account? Sign In",
                  style: GoogleFonts.jost(
                    color: CustomColors.getTitleColor(),
                    fontSize: 16.sp,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
