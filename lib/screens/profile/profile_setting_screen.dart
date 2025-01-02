import 'package:bill_payment/controller/auth_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/profile_controller.dart';
import 'package:bill_payment/screens/notification/notification_permission.dart';
import 'package:bill_payment/screens/profile/2fa_security.dart';
import 'package:bill_payment/screens/profile/change_password_screen.dart';
import 'package:bill_payment/screens/profile/edit_profile_screen.dart';
import 'package:bill_payment/screens/profile/identity_verificaion.dart';
import 'package:bill_payment/screens/support/support_ticket_screen.dart';
import 'package:bill_payment/theme/theme_service.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:bill_payment/widgets/bottom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSettingScreen extends StatefulWidget {
  static const String routeName = "/profileSettingScreen";
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  final profileController = Get.put(ProfileController());
  final authController = Get.put(AuthController());
  // language
  final languageController = Get.put(LanguageController());

  // theme
  final themeController = Get.put(ThemeService());
  bool switchValue = false;

  void toggleSwitch(bool value) {
    setState(() {
      switchValue = value;
      themeController.saveThemeSwitchState(switchValue);
      themeController.changeTheme();
    });
  }

  @override
  void initState() {
    super.initState();
    profileController.fetchUserInfo();
    switchValue = themeController.isSavedDarkMode();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return GetBuilder<AuthController>(builder: (authController) {
        return GetBuilder<LanguageController>(builder: (languageController) {
          return GetBuilder<ThemeService>(builder: (themeController) {
            return WillPopScope(
              onWillPop: () async {
                Get.offAllNamed(BottomNavBar.routeName);
                return true;
              },
              child: Scaffold(
                backgroundColor: switchValue ? CustomColors.bodyColorDark : CustomColors.bodyColor,
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
                                          Get.offAllNamed(BottomNavBar.routeName);
                                        },
                                        icon: Icon(
                                          CupertinoIcons.back,
                                          color: CustomColors.whiteColor,
                                          size: 28.sp,
                                        ),
                                      ),
                                      Text(
                                        languageController.getStoredData()["Profile Setting"] ?? "Profile Setting",
                                        style: GoogleFonts.jost(
                                          color: CustomColors.whiteColor,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      IconButton(
                                        hoverColor: CustomColors.primaryColor,
                                        onPressed: () {},
                                        icon: Icon(
                                          CupertinoIcons.settings,
                                          color: CustomColors.whiteColor,
                                          size: 0.sp,
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
                    profileController.userData != null
                        ? Container(
                            padding: EdgeInsets.only(top: 115.h),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                                    padding: EdgeInsets.all(20.w),
                                    decoration: BoxDecoration(
                                      color: switchValue ? CustomColors.containerColorDark : CustomColors.whiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: switchValue ? CustomColors.shadowColorDark : CustomColors.shadowColor,
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          offset: const Offset(0, 2),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(12.w),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(50.w),
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 100,
                                                height: 100,
                                                color: CustomColors.primaryLight,
                                              ),
                                              Positioned(
                                                child: Image.network(
                                                  profileController.userData!.userImage,
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 20.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                profileController.userData!.name,
                                                style: GoogleFonts.jost(
                                                  color: switchValue
                                                      ? CustomColors.titleColorDark
                                                      : CustomColors.titleColor,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                profileController.userData!.username,
                                                style: GoogleFonts.jost(
                                                  color:
                                                      switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                                    padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 10.h),
                                    decoration: BoxDecoration(
                                      color: switchValue ? CustomColors.containerColorDark : CustomColors.whiteColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: switchValue ? CustomColors.shadowColorDark : CustomColors.shadowColor,
                                          blurRadius: 4,
                                          spreadRadius: 0,
                                          offset: const Offset(0, 2),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(12.w),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          languageController.getStoredData()["Theme"] ?? "Theme",
                                          style: GoogleFonts.jost(
                                            color: CustomColors.primaryColor,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
                                          leading: Icon(
                                            CupertinoIcons.moon,
                                            color: switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                          ),
                                          title: Text(
                                            languageController.getStoredData()["Dark Mode"] ?? "Dark Mode",
                                            style: GoogleFonts.jost(
                                              color: switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          trailing: Transform.scale(
                                            scale: .8,
                                            child: CupertinoSwitch(
                                              value: switchValue,
                                              activeColor: CustomColors.primaryColor,
                                              onChanged: (value) {
                                                toggleSwitch(value);
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 18.h),
                                        Text(
                                          languageController.getStoredData()["Profile Setting"] ?? "Profile Setting",
                                          style: GoogleFonts.jost(
                                            color: CustomColors.primaryColor,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: switchValue
                                                    ? CustomColors.borderColorDark
                                                    : CustomColors.shadowColor,
                                                width: 1.w,
                                              ),
                                            ),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              Get.toNamed(EditProfileScreen.routeName);
                                            },
                                            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
                                            leading: Icon(
                                              CupertinoIcons.person,
                                              color: switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                            ),
                                            title: Text(
                                              languageController.getStoredData()["Edit Profile"] ?? "Edit Profile",
                                              style: GoogleFonts.jost(
                                                color:
                                                    switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: switchValue
                                                    ? CustomColors.borderColorDark
                                                    : CustomColors.shadowColor,
                                                width: 1.w,
                                              ),
                                            ),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              Get.toNamed(ChangePasswordScreen.routeName);
                                            },
                                            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
                                            leading: Icon(
                                              CupertinoIcons.lock,
                                              color: switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                            ),
                                            title: Text(
                                              languageController.getStoredData()["Change Password"] ??
                                                  "Change Password",
                                              style: GoogleFonts.jost(
                                                color:
                                                    switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: switchValue
                                                    ? CustomColors.borderColorDark
                                                    : CustomColors.shadowColor,
                                                width: 1.w,
                                              ),
                                            ),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              Get.toNamed(IdentityVerificationScreen.routeName);
                                            },
                                            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
                                            leading: Icon(
                                              Icons.verified_outlined,
                                              color: switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                            ),
                                            title: Text(
                                              languageController.getStoredData()["KYC Verification"] ??
                                                  "KYC Verification",
                                              style: GoogleFonts.jost(
                                                color:
                                                    switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: switchValue
                                                    ? CustomColors.borderColorDark
                                                    : CustomColors.shadowColor,
                                                width: 1.w,
                                              ),
                                            ),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              Get.toNamed(TwoFactorAuthenticationScreen.routeName);
                                            },
                                            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
                                            leading: Icon(
                                              Icons.verified_user_outlined,
                                              color: switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                            ),
                                            title: Text(
                                              languageController.getStoredData()["2FA Security"] ?? "2FA Security",
                                              style: GoogleFonts.jost(
                                                color:
                                                    switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: switchValue
                                                    ? CustomColors.borderColorDark
                                                    : CustomColors.shadowColor,
                                                width: 1.w,
                                              ),
                                            ),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              Get.toNamed(SupportTicketScreen.routeName);
                                            },
                                            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
                                            leading: Icon(
                                              CupertinoIcons.headphones,
                                              color: switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                            ),
                                            title: Text(
                                              languageController.getStoredData()["Support Ticket"] ?? "Support Ticket",
                                              style: GoogleFonts.jost(
                                                color:
                                                    switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: switchValue
                                                    ? CustomColors.borderColorDark
                                                    : CustomColors.shadowColor,
                                                width: 1.w,
                                              ),
                                            ),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              Get.toNamed(NotificationPermissionScreen.routeName);
                                            },
                                            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
                                            leading: Icon(
                                              CupertinoIcons.bell,
                                              color: switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                            ),
                                            title: Text(
                                              languageController.getStoredData()["Notification Permission"] ??
                                                  "Notification Permission",
                                              style: GoogleFonts.jost(
                                                color:
                                                    switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.transparent,
                                                width: 0.w,
                                              ),
                                            ),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                    titlePadding: EdgeInsets.all(0.w),
                                                    backgroundColor: switchValue
                                                        ? CustomColors.containerColorDark
                                                        : CustomColors.whiteColor,
                                                    surfaceTintColor: Colors.transparent,
                                                    title: Stack(
                                                      children: [
                                                        Positioned.fill(
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(10.w),
                                                              topRight: Radius.circular(10.w),
                                                            ),
                                                            child: Image.asset(
                                                              "assets/background.png",
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.all(20.w),
                                                          child: Center(
                                                            child: Text(
                                                              languageController.getStoredData()["Are you sure?"] ??
                                                                  "Are you sure?",
                                                              style: GoogleFonts.jost(
                                                                color: CustomColors.whiteColor,
                                                                fontSize: 20.sp,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(height: 10.h),
                                                        RichText(
                                                          text: TextSpan(
                                                            text: languageController
                                                                    .getStoredData()["Do you want to sign out?"] ??
                                                                "Do you want to sign out?",
                                                            style: GoogleFonts.jost(
                                                              color: switchValue
                                                                  ? CustomColors.textColorDark
                                                                  : CustomColors.textColor,
                                                              fontSize: 16.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 25.h),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: 8.h, horizontal: 12.w),
                                                                width: 100.w,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: CustomColors.secondaryColor,
                                                                ),
                                                                child: Text(
                                                                  languageController.getStoredData()["No"] ?? "No",
                                                                  textAlign: TextAlign.center,
                                                                  style: GoogleFonts.jost(
                                                                    color: CustomColors.whiteColor,
                                                                    fontSize: 16.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: authController.logout,
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: 8.h, horizontal: 12.w),
                                                                width: 100.w,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: CustomColors.primaryColor,
                                                                ),
                                                                child: Text(
                                                                  languageController.getStoredData()["Yes"] ?? "Yes",
                                                                  textAlign: TextAlign.center,
                                                                  style: GoogleFonts.jost(
                                                                    color: CustomColors.whiteColor,
                                                                    fontSize: 16.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
                                            leading: Icon(
                                              Icons.logout,
                                              color: switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                            ),
                                            title: Text(
                                              languageController.getStoredData()["Sign Out"] ?? "Sign Out",
                                              style: GoogleFonts.jost(
                                                color:
                                                    switchValue ? CustomColors.textColorDark : CustomColors.textColor,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            trailing: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 18.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(CustomColors.primaryColor),
                              strokeWidth: 2.0,
                            ),
                          ),
                  ],
                ),
              ),
            );
          });
        });
      });
    });
  }
}
