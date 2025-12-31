// lib/features/custom_qr/data/models/qr_input_model.dart
import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_qr_cafe/core/enums/qr_type.dart';
import 'package:my_qr_cafe/features/custom_qr/models/bank_model.dart';

part 'qr_input_model.freezed.dart';

@freezed
abstract class QrInputModel with _$QrInputModel {
  const factory QrInputModel({
    Bank? selectedBank,
    @Default('') String accountNumber,
    @Default('') String merchantName,
    @Default(0) double amount,
    @Default('') String description, // Đây là chuỗi final sau khi đã ghép
    @Default(QrType.personal) QrType type,

    // Thêm 2 trường bắt buộc cho Business
    @Default('5999') String mcc, // 5999: General Merchant (Mặc định an toàn)
    @Default('Vietnam') String merchantCity,

    Uint8List? logoBytes,
  }) = _QrInputModel;
}
