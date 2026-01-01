// lib/features/custom_qr/models/qr_input_model/qr_input_model.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_qr_cafe/core/enums/qr_type.dart';
import 'package:my_qr_cafe/features/custom_qr/models/bank_model.dart';
// [MỚI] Import thư viện QR để dùng Enum
import 'package:qr_flutter/qr_flutter.dart';

part 'qr_input_model.freezed.dart';

@freezed
abstract class QrInputModel with _$QrInputModel {
  const factory QrInputModel({
    Bank? selectedBank,
    @Default('') String accountNumber,
    @Default('') String merchantName,
    @Default(0) double amount,
    @Default('') String description,
    @Default(QrType.personal) QrType type,
    @Default('5999') String mcc,
    @Default('Vietnam') String merchantCity,
    Uint8List? logoBytes,

    // Màu sắc
    @Default(Colors.black) Color dataColor,
    @Default(Colors.black) Color eyeColor,
    @Default(Colors.white) Color bgColor,

    // [MỚI] Hình dáng QR (Style)
    @Default(QrDataModuleShape.circle)
    QrDataModuleShape qrDataShape, // Chấm dữ liệu
    @Default(QrEyeShape.square) QrEyeShape qrEyeShape, // Mắt định vị
  }) = _QrInputModel;
}
