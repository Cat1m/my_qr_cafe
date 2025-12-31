// lib/features/custom_qr/data/models/bank_model.dart

class BankResponse {
  final String code;
  final String desc;
  final List<Bank> data;

  BankResponse({required this.code, required this.desc, required this.data});

  factory BankResponse.fromJson(Map<String, dynamic> json) {
    return BankResponse(
      code: json['code'] ?? '',
      desc: json['desc'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => Bank.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Bank {
  final int id;
  final String name;
  final String code;
  final String bin;
  final String shortName;
  final String logo;
  final int transferSupported;
  final int lookupSupported;
  final int support;
  final int isTransfer;
  final String? swiftCode;

  Bank({
    required this.id,
    required this.name,
    required this.code,
    required this.bin,
    required this.shortName,
    required this.logo,
    required this.transferSupported,
    required this.lookupSupported,
    required this.support,
    required this.isTransfer,
    this.swiftCode,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      bin: json['bin'] ?? '',
      shortName: json['shortName'] ?? '',
      logo: json['logo'] ?? '',
      transferSupported: json['transferSupported'] ?? 0,
      lookupSupported: json['lookupSupported'] ?? 0,
      support: json['support'] ?? 0,
      isTransfer: json['isTransfer'] ?? 0,
      swiftCode: json['swift_code'], // Note: JSON key is 'swift_code'
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'bin': bin,
      'shortName': shortName,
      'logo': logo,
      'transferSupported': transferSupported,
      'lookupSupported': lookupSupported,
      'support': support,
      'isTransfer': isTransfer,
      'swift_code': swiftCode,
    };
  }
}
