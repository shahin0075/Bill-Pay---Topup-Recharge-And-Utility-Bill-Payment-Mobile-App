import 'package:bill_payment/controller/bill_category_controller.dart';
import 'package:bill_payment/controller/payment_controller.dart';
import 'package:bill_payment/screens/auth/password_recovery_screen.dart';
import 'package:bill_payment/screens/auth/signin_screen.dart';
import 'package:bill_payment/screens/auth/signup_screen.dart';
import 'package:bill_payment/screens/bill/bill_pay_form_screen.dart';
import 'package:bill_payment/screens/bill/bill_request_screen.dart';
import 'package:bill_payment/screens/bill/billpay_screen.dart';
import 'package:bill_payment/screens/bill/card_payment_screen.dart';
import 'package:bill_payment/screens/bill/payment_screen.dart';
import 'package:bill_payment/screens/home_screen.dart';
import 'package:bill_payment/screens/notification/notification_permission.dart';
import 'package:bill_payment/screens/notification/notification_screen.dart';
import 'package:bill_payment/screens/notification/notification_service.dart';
import 'package:bill_payment/screens/onboard/onboarding_screen.dart';
import 'package:bill_payment/screens/bill/pay_list_screen.dart';
import 'package:bill_payment/screens/onboard/welcome_screen.dart';
import 'package:bill_payment/screens/profile/2fa_security.dart';
import 'package:bill_payment/screens/profile/change_password_screen.dart';
import 'package:bill_payment/screens/profile/edit_profile_screen.dart';
import 'package:bill_payment/screens/profile/email_verification.dart';
import 'package:bill_payment/screens/profile/identity_verificaion.dart';
import 'package:bill_payment/screens/profile/profile_setting_screen.dart';
import 'package:bill_payment/screens/profile/sms_verification.dart';
import 'package:bill_payment/screens/splash/splash_screen.dart';
import 'package:bill_payment/screens/support/create_ticket_screen.dart';
import 'package:bill_payment/screens/support/support_conversation.dart';
import 'package:bill_payment/screens/support/support_ticket_screen.dart';
import 'package:bill_payment/screens/transaction_screen.dart';
import 'package:bill_payment/theme/theme_service.dart';
import 'package:bill_payment/utils/app_constants.dart';
import 'package:bill_payment/theme/app_theme.dart';
import 'package:bill_payment/widgets/bottom_navbar.dart';
import 'package:bill_payment/widgets/web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/bill/bill_detail_screen.dart';

NotificationService notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  notificationService.initialiseNotification();
  await GetStorage.init(); // getting notifications
  Stripe.publishableKey = "pk_test_AU3G7doZ1sbdpJLj0NaozPBu";

  Get.put(SdkPaymentHandle()); // make sure this is first
  Get.put(BillPayController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      child: Builder(
        builder: (context) {
          return GetMaterialApp(
            title: AppConstants.appName,
            initialRoute: SplashScreen.routeName,
            debugShowCheckedModeBanner: false,
            getPages: [
              GetPage(
                  name: WelcomeScreen.routeName,
                  page: () => const WelcomeScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: OnBoardingScreen.routeName,
                  page: () => const OnBoardingScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: HomeScreen.routeName,
                  page: () => const HomeScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: SplashScreen.routeName,
                  page: () => const SplashScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: BottomNavBar.routeName,
                  page: () => const BottomNavBar(selectedIndex: 0),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: SignInScreen.routeName,
                  page: () => const SignInScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: SignUpScreen.routeName,
                  page: () => const SignUpScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: PayListScreen.routeName,
                  page: () => const PayListScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: TransactionScreen.routeName,
                  page: () => const TransactionScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: SupportTicketScreen.routeName,
                  page: () => const SupportTicketScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: CreateTicketScreen.routeName,
                  page: () => const CreateTicketScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: SupportConversationScreen.routeName,
                  page: () => const SupportConversationScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: ProfileSettingScreen.routeName,
                  page: () => const ProfileSettingScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: EditProfileScreen.routeName,
                  page: () => const EditProfileScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: ChangePasswordScreen.routeName,
                  page: () => const ChangePasswordScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: IdentityVerificationScreen.routeName,
                  page: () => const IdentityVerificationScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: TwoFactorAuthenticationScreen.routeName,
                  page: () => const TwoFactorAuthenticationScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: BillPayScreen.routeName,
                  page: () => const BillPayScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: BillPayFormScreen.routeName,
                  page: () => const BillPayFormScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: PaymentScreen.routeName,
                  page: () => const PaymentScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: BillRequestScreen.routeName,
                  page: () => const BillRequestScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: BillDetailScreen.routeName,
                  page: () => const BillDetailScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: NotificationScreen.routeName,
                  page: () => const NotificationScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: NotificationPermissionScreen.routeName,
                  page: () => const NotificationPermissionScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: EmailVerification.routeName,
                  page: () => const EmailVerification(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: SmsVerification.routeName,
                  page: () => const SmsVerification(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: PasswordRecoveryScreen.routeName,
                  page: () => const PasswordRecoveryScreen(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: CustomWebView.routeName,
                  page: () => const CustomWebView(),
                  transition: Transition.rightToLeftWithFade),
              GetPage(
                  name: CardPaymentScreen.routeName,
                  page: () => const CardPaymentScreen(),
                  transition: Transition.rightToLeftWithFade),
            ],
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeService().getThemeMode(),
          );
        },
      ),
    );
  }
}
