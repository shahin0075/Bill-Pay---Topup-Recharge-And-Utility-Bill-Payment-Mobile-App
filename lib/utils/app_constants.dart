class AppConstants {
  static String appName = 'Bill Payment';

  static const String token = '';

  // Base URL
  static const String baseUri = ''; // Add your website url here

  // End Point
  static const String dashboardUri = '/api/dashboard';
  static const String ticketListUri = '/api/support-ticket/list';
  static const String createTicketUri = '/api/support-ticket/create';
  static const String ticketViewUri = '/api/support-ticket/view/';
  static const String ticketReplyUri = '/api/support-ticket/reply';
  static const String twoFaUri = '/api/2FA-security';
  static const String enableTwoFaUri = '/api/2FA-security/enable';
  static const String disableTwoFaUri = '/api/2FA-security/disable';
  static const String profileUri = '/api/profile';
  static const String registerUri = '/api/register';
  static const String loginUri = '/api/login';
  static const String notificationPermissionUri = '/api/notification';
  static const String notificationSubmitUri = '/api/notification/submit';
  static const String pusherConfigUri = '/api/pusher/config';

  static const String transactionUri = '/api/transaction/search';
  static const String billPayListUri = '/api/bill-pay/list';
  static const String billDetailUri = '/api/bill-pay/details/';
  static const String billCategoryUri = '/api/bill-category';
  static const String billRequestUri = '/api/bill-request';
  static const String billFormUri = '/api/pay-bill/form/';
  static const String billFormSubmitUri = '/api/pay-bill/form/submit';
  static const String billPreviewUri = '/api/bill-pay/preview/';
  static const String profileImageUploadUri = '/api/profile/image/upload';
  static const String profileInfoUpdateUri = '/api/profile/information/update';
  static const String profilePassUpdateUri = '/api/profile/password/update';
  static const String identityVerificationUri = '/api/profile/identity-verification';
  static const String identityVerificationSubmissionUri = '/api/profile/identity-verification/submit';

  static const String emailVerifyUri = '/api/mail-verify';
  static const String smsVerifyUri = '/api/sms-verify';
  static const String resendCodeUri = '/api/resend-code';

  static const String getCodeUri = '/api/recovery-pass/get-email';
  static const String codeValidationUri = '/api/recovery-pass/get-code';
  static const String resetPasswordUri = '/api/update-pass';

  static const String manualPaymentUri = '/api/manual/payment/submit';
  static const String walletPaymentUri = '/api/wallet-payment';
  static const String autoPaymentUri = '/api/automation/payment';
  static const String cardPaymentUri = '/api/card/payment';
  static const String paymentDoneUri = '/api/payment/done';

  static const String languageUri = '/api/language/';
  static const String appConfigUri = '/api/app/config';
  static const String userDataUri = '/api/user-data';

  static void updateConstantsFromApi(Map<String, dynamic> apiData) {
    if (apiData.containsKey("siteTitle") && apiData.containsKey("primaryColor")) {
      appName = apiData["siteTitle"];
    }
  }
}
