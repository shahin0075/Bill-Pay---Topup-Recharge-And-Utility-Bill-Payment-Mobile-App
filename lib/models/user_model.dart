class UserModel {
  final String userImage;
  final String name;
  final dynamic city;
  final String username;
  final String email;
  final String phoneCode;
  final String phone;
  final dynamic address;
  final List<LanguageModel> languages;

  UserModel({
    required this.userImage,
    required this.name,
    required this.city,
    required this.username,
    required this.email,
    required this.phoneCode,
    required this.phone,
    required this.address,
    required this.languages,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<LanguageModel> languagesList = [];
    if (json['languages'] != null) {
      languagesList = List<LanguageModel>.from(
        json['languages'].map(
          (language) => LanguageModel.fromJson(language),
        ),
      );
    }
    return UserModel(
      userImage: json['userImage'],
      name: json['name'],
      city: json['city'],
      username: json['username'],
      email: json['email'],
      phoneCode: json['phoneCode'],
      phone: json['phone'],
      address: json['address'],
      languages: languagesList,
    );
  }
}

class LanguageModel {
  final dynamic id;
  final dynamic name;
  final dynamic shortName;
  final dynamic flag;
  final dynamic isActive;
  final dynamic rtl;
  final dynamic defaultStatus;

  LanguageModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.flag,
    required this.isActive,
    required this.rtl,
    required this.defaultStatus,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['id'],
      name: json['name'],
      shortName: json['short_name'],
      flag: json['flag'],
      isActive: json['is_active'],
      rtl: json['rtl'],
      defaultStatus: json['default_status'],
    );
  }
}

class BillRecord {
  final dynamic pendingBills;
  final dynamic completeBills;
  final dynamic returnBills;
  final dynamic totalWalletPays;
  final dynamic walletBalance;

  BillRecord({
    required this.pendingBills,
    required this.completeBills,
    required this.returnBills,
    required this.totalWalletPays,
    required this.walletBalance,
  });

  factory BillRecord.fromJson(Map<String, dynamic> json) {
    return BillRecord(
      pendingBills: json['pendingBills'],
      completeBills: json['completeBills'],
      returnBills: json['returnBills'],
      totalWalletPays: json['totalWalletPays'],
      walletBalance: json['walletBalance'],
    );
  }
}
