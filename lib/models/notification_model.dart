class NotificationPermission {
  final dynamic templateKey;
  final dynamic name;
  final dynamic smsStatus;
  final dynamic mailStatus;
  final dynamic inAppStatus;
  final dynamic pushStatus;

  NotificationPermission({
    required this.templateKey,
    required this.name,
    required this.smsStatus,
    required this.mailStatus,
    required this.inAppStatus,
    required this.pushStatus,
  });

  factory NotificationPermission.fromJson(Map<String, dynamic> json) {
    return NotificationPermission(
      templateKey: json['template_key'],
      name: json['name'],
      smsStatus: json['sms_status'],
      mailStatus: json['mail_status'],
      inAppStatus: json['in_app_status'],
      pushStatus: json['push_status'],
    );
  }
}
