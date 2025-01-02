import 'dart:io';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/controller/profile_controller.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = "/editProfileScreen";
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? _pickedUserImage;

  // coming from controller
  final profileController = Get.put(ProfileController());
  // language
  final languageController = Get.put(LanguageController());

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        // Update the user image based on the picked image
        _pickedUserImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    profileController.fetchUserInfo().then((value) => {
          profileController.nameController.text = profileController.userData!.name,
          profileController.usernameController.text = profileController.userData!.username,
          profileController.phoneController.text = profileController.userData!.phone,
          profileController.emailController.text = profileController.userData!.email,
          profileController.cityController.text = profileController.userData!.city,
          profileController.addressController.text = profileController.userData!.address,
        });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return GetBuilder<LanguageController>(builder: (languageController) {
        return RefreshIndicator(
          onRefresh: profileController.fetchUserInfo,
          color: CustomColors.primaryColor,
          child: Scaffold(
              backgroundColor: CustomColors.getBodyColor(),
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
                                      languageController.getStoredData()["Edit Profile"] ?? "Edit Profile",
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
                  !profileController.isLoading
                      ? Container(
                          padding: EdgeInsets.only(top: 115.h),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 20.h, bottom: 0.h, left: 20.w, right: 20.w),
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    color: CustomColors.getContainerColor(),
                                    boxShadow: [
                                      BoxShadow(
                                        color: CustomColors.getShadowColor(),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12.w),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(100.w),
                                                child: _pickedUserImage == null
                                                    ? Image.network(
                                                        profileController.userData!.userImage,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(
                                                        _pickedUserImage!,
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                      color: CustomColors.primaryColor,
                                                      borderRadius: BorderRadius.circular(35.w)),
                                                  child: IconButton(
                                                    onPressed: _pickImage,
                                                    icon: Icon(
                                                      CupertinoIcons.camera,
                                                      color: CustomColors.whiteColor,
                                                      size: 18.sp,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.h),
                                      GestureDetector(
                                        onTap: () {
                                          profileController.profileImageUpload(_pickedUserImage!);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                                          width: 150.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: CustomColors.primaryColor,
                                          ),
                                          child: !profileController.isLoading
                                              ? Text(
                                                  languageController.getStoredData()["Upload Image"] ?? "Upload Image",
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
                                                      valueColor:
                                                          AlwaysStoppedAnimation<Color>(CustomColors.whiteColor),
                                                      strokeWidth: 2.0,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    color: CustomColors.getContainerColor(),
                                    boxShadow: [
                                      BoxShadow(
                                        color: CustomColors.getShadowColor(),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12.w),
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          languageController.getStoredData()["Personal Information"] ??
                                              "Personal Information",
                                          style: GoogleFonts.jost(
                                            color: CustomColors.getTitleColor(),
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        TextFormField(
                                          controller: profileController.nameController,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return languageController
                                                      .getStoredData()['This field can not be empty'] ??
                                                  'This field can not be empty';
                                            }
                                            return null;
                                          },
                                          style: GoogleFonts.getFont(
                                            'Jost',
                                            textStyle: TextStyle(
                                              fontSize: 16.sp,
                                              color: CustomColors.getTextColor(),
                                            ),
                                          ),
                                          decoration: InputDecoration(
                                            labelText: languageController.getStoredData()["Name"] ?? "Name",
                                            labelStyle: GoogleFonts.jost(
                                              color: CustomColors.getTextColor(),
                                            ),
                                            contentPadding: EdgeInsets.all(14.w),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide(
                                                color: CustomColors.primaryColor,
                                                width: 1.w,
                                              ),
                                            ),
                                            errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                                            filled: true,
                                            fillColor: CustomColors.getInputColor(),
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        TextFormField(
                                          controller: profileController.usernameController,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return languageController
                                                      .getStoredData()['This field can not be empty'] ??
                                                  'This field can not be empty';
                                            }
                                            return null;
                                          },
                                          style: GoogleFonts.getFont(
                                            'Jost',
                                            textStyle: TextStyle(
                                              fontSize: 16.sp,
                                              color: CustomColors.getTextColor(),
                                            ),
                                          ),
                                          decoration: InputDecoration(
                                            labelText: languageController.getStoredData()["Username"] ?? "Username",
                                            labelStyle: GoogleFonts.jost(
                                              color: CustomColors.getTextColor(),
                                            ),
                                            contentPadding: EdgeInsets.all(14.w),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide(
                                                color: CustomColors.primaryColor,
                                                width: 1.w,
                                              ),
                                            ),
                                            errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                                            filled: true,
                                            fillColor: CustomColors.getInputColor(),
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        TextFormField(
                                          controller: profileController.phoneController,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return languageController
                                                      .getStoredData()['This field can not be empty'] ??
                                                  'This field can not be empty';
                                            }
                                            return null;
                                          },
                                          style: GoogleFonts.getFont(
                                            'Jost',
                                            textStyle: TextStyle(
                                              fontSize: 16.sp,
                                              color: CustomColors.getTextColor(),
                                            ),
                                          ),
                                          decoration: InputDecoration(
                                            labelText: languageController.getStoredData()["Phone"] ?? "Phone",
                                            labelStyle: GoogleFonts.jost(
                                              color: CustomColors.getTextColor(),
                                            ),
                                            contentPadding: EdgeInsets.all(14.w),
                                            // prefixText: "+880",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide(
                                                color: CustomColors.primaryColor,
                                                width: 1.w,
                                              ),
                                            ),
                                            errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                                            filled: true,
                                            fillColor: CustomColors.getInputColor(),
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        TextFormField(
                                          controller: profileController.emailController,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return languageController
                                                      .getStoredData()['This field can not be empty'] ??
                                                  'This field can not be empty';
                                            }
                                            return null;
                                          },
                                          style: GoogleFonts.getFont(
                                            'Jost',
                                            textStyle: TextStyle(
                                              fontSize: 16.sp,
                                              color: CustomColors.getTextColor(),
                                            ),
                                          ),
                                          decoration: InputDecoration(
                                            labelText: languageController.getStoredData()["Email"] ?? "Email",
                                            labelStyle: GoogleFonts.jost(
                                              color: CustomColors.getTextColor(),
                                            ),
                                            contentPadding: EdgeInsets.all(14.w),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide(
                                                color: CustomColors.primaryColor,
                                                width: 1.w,
                                              ),
                                            ),
                                            errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                                            filled: true,
                                            fillColor: CustomColors.getInputColor(),
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        DropdownButtonFormField2<String>(
                                          isExpanded: true,
                                          decoration: InputDecoration(
                                            labelText: languageController.getStoredData()["Language"] ?? "Language",
                                            labelStyle: GoogleFonts.jost(
                                              color: CustomColors.getTextColor(),
                                            ),
                                            contentPadding: EdgeInsets.all(14.w),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide(
                                                color: CustomColors.primaryColor,
                                                width: 1.w,
                                              ),
                                            ),
                                            errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                                            filled: true,
                                            fillColor: CustomColors.getInputColor(),
                                          ),
                                          value: profileController.selectedLanguage,
                                          items: profileController.userData!.languages
                                              .asMap() // Access index and value using asMap()
                                              .map((index, language) => MapEntry(
                                                    index,
                                                    DropdownMenuItem<String>(
                                                      value: language.name,
                                                      child: Text(
                                                        language.name,
                                                        style: GoogleFonts.jost(
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.w400,
                                                          color: CustomColors.getTextColor(),
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ))
                                              .values
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              profileController.selectedLanguage = value;
                                              profileController.selectedLanguageIndex = profileController
                                                      .userData!.languages
                                                      .indexWhere((language) => language.name == value) +
                                                  1;
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            padding: EdgeInsets.all(0.w),
                                          ),
                                          iconStyleData: IconStyleData(
                                            icon: Icon(
                                              CupertinoIcons.chevron_down,
                                              color: CustomColors.getTextColor(),
                                            ),
                                            iconSize: 18,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 300,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(14.w),
                                              color: CustomColors.getInputColor(),
                                            ),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness: MaterialStateProperty.all(3),
                                              thumbVisibility: MaterialStateProperty.all(true),
                                              thumbColor: const MaterialStatePropertyAll(CustomColors.backgroundColor),
                                            ),
                                          ),
                                          menuItemStyleData: MenuItemStyleData(
                                            padding: EdgeInsets.only(left: 14.w),
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        TextFormField(
                                          controller: profileController.cityController,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return languageController
                                                      .getStoredData()['This field can not be empty'] ??
                                                  'This field can not be empty';
                                            }
                                            return null;
                                          },
                                          style: GoogleFonts.getFont(
                                            'Jost',
                                            textStyle: TextStyle(
                                              fontSize: 16.sp,
                                              color: CustomColors.getTextColor(),
                                            ),
                                          ),
                                          decoration: InputDecoration(
                                            labelText: languageController.getStoredData()["City"] ?? "City",
                                            labelStyle: GoogleFonts.jost(
                                              color: CustomColors.getTextColor(),
                                            ),
                                            contentPadding: EdgeInsets.all(14.w),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide(
                                                color: CustomColors.primaryColor,
                                                width: 1.w,
                                              ),
                                            ),
                                            errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                                            filled: true,
                                            fillColor: CustomColors.getInputColor(),
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        TextFormField(
                                          controller: profileController.addressController,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return languageController
                                                      .getStoredData()['This field can not be empty'] ??
                                                  'This field can not be empty';
                                            }
                                            return null;
                                          },
                                          maxLines: 3,
                                          style: GoogleFonts.getFont(
                                            'Jost',
                                            textStyle: TextStyle(
                                              fontSize: 16.sp,
                                              color: CustomColors.getTextColor(),
                                            ),
                                          ),
                                          decoration: InputDecoration(
                                            labelText: languageController.getStoredData()["Address"] ?? "Address",
                                            labelStyle: GoogleFonts.jost(
                                              color: CustomColors.getTextColor(),
                                            ),
                                            contentPadding: EdgeInsets.all(14.w),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8.w),
                                              borderSide: BorderSide(
                                                color: CustomColors.primaryColor,
                                                width: 1.w,
                                              ),
                                            ),
                                            errorStyle: GoogleFonts.jost(color: CustomColors.secondaryColor),
                                            filled: true,
                                            fillColor: CustomColors.getInputColor(),
                                          ),
                                        ),
                                        SizedBox(height: 16.h),
                                        GestureDetector(
                                          onTap: () {
                                            if (_formKey.currentState!.validate()) {
                                              profileController.postPersonalInfo();
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                                            width: 300.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: CustomColors.primaryColor,
                                            ),
                                            child: !profileController.isLoading
                                                ? Text(
                                                    languageController.getStoredData()["Save Changes"] ??
                                                        "Save Changes",
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
                                                        valueColor:
                                                            AlwaysStoppedAnimation<Color>(CustomColors.whiteColor),
                                                        strokeWidth: 2.0,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
              )),
        );
      });
    });
  }
}
