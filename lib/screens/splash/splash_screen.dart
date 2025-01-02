import 'package:bill_payment/controller/app_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/onboard/onboarding_screen.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:bill_payment/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final languageController = Get.put(LanguageController());
  final appController = Get.put(AppController());
  int? selectedLanguageIndex;

  _checkIfOnboardingShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingShown = prefs.getBool('onboardingShown') ?? false;
    String? authToken = prefs.getString(AppConstants.token);

    if (onboardingShown) {
      if (authToken != null) {
        Get.offAllNamed(BottomNavBar.routeName);
      } else {
        Get.offAllNamed(SignInScreen.routeName);
      }
    } else {
      Get.offAllNamed(OnBoardingScreen.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedLanguageIndex = GetStorage().read<int>('languageIndex') ?? 1;
    languageController.fetchLanguageData(selectedLanguageIndex!);
    appController.fetchColors();

    Future.delayed(const Duration(seconds: 2), () {
      _checkIfOnboardingShown();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Delay for 2 seconds and then navigate to the main screen
    // Future.delayed(const Duration(seconds: 3), () {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (context) => const OnBoardingScreen(), // Replace with your main screen
    //     ),
    //   );
    // });

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/splash.png",
            fit: BoxFit.cover,
            height: double.infinity.h,
            width: double.infinity.w,
          ),
          Positioned(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(100.w)),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    "assets/icon/logo.png",
                    fit: BoxFit.contain,
                    height: 80.h,
                    width: 150.w,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
