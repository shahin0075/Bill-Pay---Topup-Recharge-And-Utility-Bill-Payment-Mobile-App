import 'package:bill_payment/data/onboard_data.dart';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/onboard/welcome_screen.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/widgets/dot_indicator.dart';
import 'package:bill_payment/widgets/onboard_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatefulWidget {
  static const String routeName = "/onBoardingScreen";
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  _markOnboardingAsShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboardingShown', true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToNextPage() {
    _markOnboardingAsShown();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300), // Animation duration
      curve: Curves.easeInOut, // Animation curve
    );
    if (_currentPage == onboardData.length - 1) {
      // _markOnboardingAsShown();
      Get.offAllNamed(WelcomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            // Carousel area
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onboardData.length,
                controller: _pageController,
                itemBuilder: (context, index) => OnBoardContent(
                  image: onboardData[index].image,
                  title: onboardData[index].title,
                  description: onboardData[index].description,
                ),
              ),
            ),
            // Indicator area
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    onboardData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: DotIndicator(
                        isActive: index == _currentPage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100.h),
            GestureDetector(
              onTap: _navigateToNextPage,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
                width: 300.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CustomColors.primaryColor,
                ),
                child: Text(
                  _currentPage == onboardData.length - 1 ? 'Get Started' : "Next Page",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jost(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            TextButton(
              onPressed: () {
                Get.toNamed(SignInScreen.routeName);
                _markOnboardingAsShown();
              },
              child: Text(
                "Skip",
                style: GoogleFonts.jost(
                  color: CustomColors.getTitleColor(),
                  fontSize: 16.sp,
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
