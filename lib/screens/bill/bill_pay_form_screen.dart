import 'package:bill_payment/controller/bill_category_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BillPayFormScreen extends StatefulWidget {
  static const String routeName = "/billPayFormScreen";
  const BillPayFormScreen({super.key});

  @override
  State<BillPayFormScreen> createState() => _BillPayFormScreenState();
}

class _BillPayFormScreenState extends State<BillPayFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchCountryController = TextEditingController();
  final TextEditingController _searchServiceController = TextEditingController();
  final TextEditingController _searchAmountController = TextEditingController();

  final controller = Get.put(BillPayController());
  var key = Get.arguments as String;

  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  String convertCamelCaseToSentence(String input) {
    return input.split('_').map((word) => word.capitalize).join(' ');
  }

  @override
  void initState() {
    super.initState();
    controller.fetchBillForm(key);
    languageData = languageController.getStoredData();
  }

  @override
  void dispose() {
    Get.delete<BillPayController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillPayController>(builder: (controller) {
      return Scaffold(
        backgroundColor: CustomColors.getBodyColor(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      "assets/background.png",
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: EdgeInsets.only(top: 60.h),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                hoverColor: CustomColors.primaryColor,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  CupertinoIcons.back,
                                  color: Colors.white,
                                  size: 28.sp,
                                ),
                              ),
                              Text(
                                languageData["Pay Bill"] ?? "Pay Bill",
                                style: GoogleFonts.jost(
                                  color: Colors.white,
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                hoverColor: CustomColors.primaryColor,
                                onPressed: () {},
                                icon: Icon(
                                  CupertinoIcons.bell,
                                  color: Colors.white,
                                  size: 0.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: CustomColors.getContainerColor(),
                              borderRadius: BorderRadius.circular(16.w),
                              boxShadow: [
                                BoxShadow(
                                  color: CustomColors.getShadowColor(),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DropdownButtonFormField2<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText: languageData["Select Country"] ?? "Select Country",
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
                                    items: controller.countries
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: GoogleFonts.jost(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: CustomColors.getTextColor(),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return languageData['Please select country.'] ?? 'Please select country.';
                                      }
                                      return null;
                                    },
                                    value: controller.selectedCountry,
                                    onChanged: (value) {
                                      setState(() {
                                        controller.selectedServiceType = null;
                                        controller.selectableServices = [];
                                        controller.selectedCountry = value;
                                        controller
                                            .filterServicesByCountry(value!); // filter services using country name
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
                                        color: CustomColors.getContainerColor(),
                                      ),
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(40),
                                        thickness: MaterialStateProperty.all(3),
                                        thumbVisibility: MaterialStateProperty.all(true),
                                        thumbColor: MaterialStatePropertyAll(CustomColors.getBorderColor()),
                                      ),
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      padding: EdgeInsets.only(left: 14.w),
                                    ),

                                    dropdownSearchData: DropdownSearchData(
                                      searchController: _searchCountryController,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        margin: EdgeInsets.only(top: 12.h, left: 12.w, right: 12.w),
                                        child: TextFormField(
                                          controller: _searchCountryController,
                                          style: GoogleFonts.getFont(
                                            'Jost',
                                            textStyle: TextStyle(
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          decoration: InputDecoration(
                                            hintText: languageData["Search for country"] ?? "Search for country",
                                            hintStyle: GoogleFonts.jost(
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
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return item.value.toString().toLowerCase().contains(searchValue);
                                      },
                                    ),
                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        _searchCountryController.clear();
                                      }
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  DropdownButtonFormField2<String>(
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      labelText: languageData["Select Service"] ?? "Select Service",
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
                                    items: controller.selectableServices
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item.id.toString(),
                                              child: Text(
                                                item.type,
                                                style: GoogleFonts.jost(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: CustomColors.getTextColor(),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return languageData['Please select service'] ?? 'Please select service';
                                      }
                                      return null;
                                    },
                                    value: controller.selectedServiceType,
                                    onChanged: (value) {
                                      setState(() {
                                        controller.selectedExtraResponse = null;
                                        controller.extraResponses = [];

                                        controller.selectedServiceType = value;
                                        controller.findServiceById(value); // finding service item using service id
                                        controller.fetchExtraResponse();
                                        if (kDebugMode) {
                                          print("----------------> SERVICE FROM SERVICE TYPE ID:  $value");
                                        }
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
                                        color: CustomColors.getContainerColor(),
                                      ),
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(40),
                                        thickness: MaterialStateProperty.all(3),
                                        thumbVisibility: MaterialStateProperty.all(true),
                                        thumbColor: MaterialStatePropertyAll(CustomColors.getBorderColor()),
                                      ),
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      padding: EdgeInsets.only(left: 14.w),
                                    ),

                                    dropdownSearchData: DropdownSearchData(
                                      searchController: _searchServiceController,
                                      searchInnerWidgetHeight: 50,
                                      searchInnerWidget: Container(
                                        margin: EdgeInsets.only(top: 12.h, left: 12.w, right: 12.w),
                                        child: TextFormField(
                                          controller: _searchServiceController,
                                          style: GoogleFonts.getFont(
                                            'Jost',
                                            textStyle: TextStyle(
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          decoration: InputDecoration(
                                            hintText: languageData["Search for service"] ?? "Search for service",
                                            hintStyle: GoogleFonts.jost(
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
                                      ),
                                      searchMatchFn: (item, searchValue) {
                                        return item.value.toString().toLowerCase().contains(searchValue);
                                      },
                                    ),
                                    //This to clear the search value when you close the menu
                                    onMenuStateChange: (isOpen) {
                                      if (!isOpen) {
                                        _searchServiceController.clear();
                                      }
                                    },
                                  ),
                                  // SizedBox(height: 16.h),
                                  for (var item in controller.labelList) buildFormField(item),
                                  controller.selectedService != null
                                      ? Container(
                                          child: controller.selectedService!.amount == 0
                                              ? Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    TextFormField(
                                                      controller: controller.amountController,
                                                      keyboardType: TextInputType.number,
                                                      validator: (value) {
                                                        if (value == null || value.isEmpty) {
                                                          return languageData['Please enter amount'] ??
                                                              'Please enter amount';
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
                                                        labelText: languageData["Enter Amount"] ?? "Enter Amount",
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
                                                        errorStyle:
                                                            GoogleFonts.jost(color: CustomColors.secondaryColor),
                                                        filled: true,
                                                        fillColor: CustomColors.getInputColor(),
                                                      ),
                                                    ),
                                                    SizedBox(height: 5.h),
                                                    Text(
                                                      "You can pay min ${controller.selectedService!.minAmount} ${controller.selectedService!.currency} and max ${controller.selectedService!.maxAmount} ${controller.selectedService!.currency}",
                                                      style: GoogleFonts.jost(
                                                        fontSize: 12.sp,
                                                        color: CustomColors.infoColor,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : DropdownButtonFormField2<String>(
                                                  isExpanded: true,
                                                  decoration: InputDecoration(
                                                    labelText: languageData["Select Amount"] ?? "Select Amount",
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
                                                  items: controller.extraResponses
                                                      .map((item) => DropdownMenuItem<String>(
                                                            value: item['id'].toString(),
                                                            child: Text(
                                                              item['description'],
                                                              style: GoogleFonts.jost(
                                                                fontSize: 16.sp,
                                                                fontWeight: FontWeight.w400,
                                                                color: CustomColors.getTextColor(),
                                                              ),
                                                              overflow: TextOverflow.ellipsis,
                                                            ),
                                                          ))
                                                      .toList(),
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return languageData['Please select amount'] ??
                                                          'Please select amount';
                                                    }
                                                    return null;
                                                  },
                                                  value: controller.selectedExtraResponse,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      controller.selectedExtraResponse = value;
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
                                                      color: CustomColors.getContainerColor(),
                                                    ),
                                                    scrollbarTheme: ScrollbarThemeData(
                                                      radius: const Radius.circular(40),
                                                      thickness: MaterialStateProperty.all(3),
                                                      thumbVisibility: MaterialStateProperty.all(true),
                                                      thumbColor:
                                                          MaterialStatePropertyAll(CustomColors.getBorderColor()),
                                                    ),
                                                  ),
                                                  menuItemStyleData: MenuItemStyleData(
                                                    padding: EdgeInsets.only(left: 14.w),
                                                  ),

                                                  dropdownSearchData: DropdownSearchData(
                                                    searchController: _searchAmountController,
                                                    searchInnerWidgetHeight: 50,
                                                    searchInnerWidget: Container(
                                                      margin: EdgeInsets.only(top: 12.h, left: 12.w, right: 12.w),
                                                      child: TextFormField(
                                                        controller: _searchAmountController,
                                                        style: GoogleFonts.getFont(
                                                          'Jost',
                                                          textStyle: TextStyle(
                                                            fontSize: 16.sp,
                                                          ),
                                                        ),
                                                        decoration: InputDecoration(
                                                          hintText: languageData["Search"] ?? "Search",
                                                          hintStyle: GoogleFonts.jost(
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
                                                          errorStyle:
                                                              GoogleFonts.jost(color: CustomColors.secondaryColor),
                                                          filled: true,
                                                          fillColor: CustomColors.getInputColor(),
                                                        ),
                                                      ),
                                                    ),
                                                    searchMatchFn: (item, searchValue) {
                                                      return item.value.toString().toLowerCase().contains(searchValue);
                                                    },
                                                  ),
                                                  //This to clear the search value when you close the menu
                                                  onMenuStateChange: (isOpen) {
                                                    if (!isOpen) {
                                                      _searchAmountController.clear();
                                                    }
                                                  },
                                                ),
                                        )
                                      : const SizedBox(height: 0, width: 0),
                                  SizedBox(height: 16.h),
                                  GestureDetector(
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        controller.submitBillingInfo();
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                                      width: 300.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: CustomColors.primaryColor,
                                      ),
                                      child: !controller.isLoading
                                          ? Text(
                                              languageData["Continue"] ?? "Continue",
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget buildFormField(dynamic fieldName) {
    TextEditingController? inputController = controller.textControllers[fieldName];

    bool checkForMultipleWords(String fieldName) {
      List<String> wordsToCheck = ["number", "phone", "telephone", "contact", "amount"];
      for (String word in wordsToCheck) {
        if (fieldName.toLowerCase().contains(word)) {
          return false;
        }
      }
      return true;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h, top: 16.h),
      child: TextFormField(
        controller: inputController,
        // keyboardType: fieldName.toLowerCase().contains("number") ? TextInputType.number : TextInputType.text,
        keyboardType: checkForMultipleWords(fieldName) ? TextInputType.text : TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field can not be empty';
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
          labelText: convertCamelCaseToSentence(fieldName),
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
    );
  }
}
