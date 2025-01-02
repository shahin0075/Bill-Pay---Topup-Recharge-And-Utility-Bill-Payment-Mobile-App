import 'package:bill_payment/controller/bill_category_controller.dart';
import 'package:bill_payment/controller/language_controller.dart';
import 'package:bill_payment/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CardPaymentScreen extends StatefulWidget {
  static const String routeName = "/cardPaymentScreen";
  const CardPaymentScreen({super.key});

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final controller = Get.put(BillPayController());
  // language
  final languageController = Get.put(LanguageController());
  Map<String, dynamic> languageData = {};

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isCvvFocused = false;

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      controller.submitCardPayment();
      if (kDebugMode) {
        print('valid!');
      }
    } else {
      if (kDebugMode) {
        print('invalid!');
      }
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      controller.cardNumber = creditCardModel.cardNumber;
      controller.expiryDate = creditCardModel.expiryDate;
      controller.cardHolderName = creditCardModel.cardHolderName;
      controller.cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  void initState() {
    super.initState();
    controller.fetchBillingCategories();
    languageData = languageController.getStoredData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillPayController>(
      builder: (controller) {
        return Scaffold(
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
                                  languageData["Card Details"] ?? "Card Details",
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
                                    CupertinoIcons.search,
                                    color: Colors.white,
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
              Container(
                padding: EdgeInsets.only(top: 110.h),
                margin: EdgeInsets.all(5.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CreditCardWidget(
                        cardNumber: controller.cardNumber,
                        expiryDate: controller.expiryDate,
                        cardHolderName: controller.cardHolderName,
                        cvvCode: controller.cvvCode,
                        bankName: 'Axis Bank',
                        frontCardBorder: Border.all(color: CustomColors.primaryColor),
                        backCardBorder: Border.all(color: CustomColors.primaryColor),
                        showBackView: isCvvFocused,
                        obscureCardNumber: true,
                        obscureCardCvv: true,
                        isHolderNameVisible: true,
                        cardBgColor: CustomColors.primaryColor,
                        backgroundImage: 'assets/card.png',
                        isSwipeGestureEnabled: true,
                        onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                        customCardTypeIcons: <CustomCardTypeIcon>[
                          CustomCardTypeIcon(
                            cardType: CardType.mastercard,
                            cardImage: Image.asset(
                              'assets/icon/mastercard.png',
                              height: 48,
                              width: 48,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: CustomColors.getContainerColor(),
                          borderRadius: BorderRadius.circular(12.w),
                          boxShadow: [
                            BoxShadow(
                              color: CustomColors.getShadowColor(),
                              offset: const Offset(0, 4),
                              blurRadius: 3,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              CreditCardForm(
                                formKey: formKey,
                                obscureCvv: false,
                                obscureNumber: false,
                                cardNumber: controller.cardNumber,
                                cvvCode: controller.cvvCode,
                                isHolderNameVisible: true,
                                isCardNumberVisible: true,
                                isExpiryDateVisible: true,
                                cardHolderName: controller.cardHolderName,
                                expiryDate: controller.expiryDate,
                                inputConfiguration: InputConfiguration(
                                  cardNumberDecoration: InputDecoration(
                                    labelText: languageData['Number'] ?? 'Number',
                                    hintText: 'XXXX XXXX XXXX XXXX',
                                    hintStyle: GoogleFonts.getFont(
                                      'Jost',
                                      textStyle: TextStyle(fontSize: 16.sp, color: CustomColors.getTextColor()),
                                    ),
                                    labelStyle: GoogleFonts.getFont(
                                      'Jost',
                                      textStyle: TextStyle(fontSize: 16.sp, color: CustomColors.getTextColor()),
                                    ),
                                    contentPadding: EdgeInsets.all(12.w),
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
                                  expiryDateDecoration: InputDecoration(
                                    labelText: languageData['Expired Date'] ?? 'Expired Date',
                                    hintText: 'XX/XX',
                                    hintStyle: GoogleFonts.getFont(
                                      'Jost',
                                      textStyle: TextStyle(fontSize: 16.sp, color: CustomColors.getTextColor()),
                                    ),
                                    labelStyle: GoogleFonts.getFont(
                                      'Jost',
                                      textStyle: TextStyle(fontSize: 16.sp, color: CustomColors.getTextColor()),
                                    ),
                                    contentPadding: EdgeInsets.all(12.w),
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
                                  cvvCodeDecoration: InputDecoration(
                                    labelText: languageData['CVV'] ?? 'CVV',
                                    hintText: 'XXX',
                                    hintStyle: GoogleFonts.getFont(
                                      'Jost',
                                      textStyle: TextStyle(fontSize: 16.sp, color: CustomColors.getTextColor()),
                                    ),
                                    labelStyle: GoogleFonts.getFont(
                                      'Jost',
                                      textStyle: TextStyle(fontSize: 16.sp, color: CustomColors.getTextColor()),
                                    ),
                                    contentPadding: EdgeInsets.all(12.w),
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
                                  cardHolderDecoration: InputDecoration(
                                    labelText: languageData['Card Holder'] ?? 'Card Holder',
                                    hintStyle: GoogleFonts.getFont(
                                      'Jost',
                                      textStyle: TextStyle(fontSize: 16.sp, color: CustomColors.getTextColor()),
                                    ),
                                    labelStyle: GoogleFonts.getFont(
                                      'Jost',
                                      textStyle: TextStyle(fontSize: 16.sp, color: CustomColors.getTextColor()),
                                    ),
                                    contentPadding: EdgeInsets.all(12.w),
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
                                onCreditCardModelChange: onCreditCardModelChange,
                              ),
                              GestureDetector(
                                onTap: _onValidate,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                                  margin: EdgeInsets.all(16.w),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: CustomColors.primaryColor,
                                  ),
                                  child: !controller.isLoading
                                      ? Text(languageData["Pay"] ?? "Pay",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.jost(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                          ))
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
                              )
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
        );
      },
    );
  }
}
