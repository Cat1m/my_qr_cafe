// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QrInfoModel _$QrInfoModelFromJson(Map<String, dynamic> json) => _QrInfoModel(
  bankBin: json['bankBin'] as String,
  accountNumber: json['accountNumber'] as String,
  accountName: json['accountName'] as String? ?? 'KHACH HANG',
  amount: json['amount'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$QrInfoModelToJson(_QrInfoModel instance) =>
    <String, dynamic>{
      'bankBin': instance.bankBin,
      'accountNumber': instance.accountNumber,
      'accountName': instance.accountName,
      'amount': instance.amount,
      'description': instance.description,
    };
