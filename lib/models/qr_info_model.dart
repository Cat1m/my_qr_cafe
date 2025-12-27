import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_info_model.freezed.dart';
part 'qr_info_model.g.dart';

@freezed
abstract class QrInfoModel with _$QrInfoModel {
  const factory QrInfoModel({
    required String bankBin,
    required String accountNumber,
    @Default('KHACH HANG') String accountName,
    String? amount,
    String? description,
  }) = _QrInfoModel;

  factory QrInfoModel.fromJson(Map<String, dynamic> json) =>
      _$QrInfoModelFromJson(json);
}
