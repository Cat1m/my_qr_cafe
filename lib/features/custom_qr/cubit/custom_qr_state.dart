// lib/features/custom_qr/logic/custom_qr_state.dart
import 'package:my_qr_cafe/features/custom_qr/models/bank_model.dart';
import 'package:my_qr_cafe/features/custom_qr/models/qr_input_model/qr_input_model.dart';

sealed class CustomQrState {
  const CustomQrState();
}

class CustomQrInitial extends CustomQrState {
  const CustomQrInitial();
}

class CustomQrLoading extends CustomQrState {
  const CustomQrLoading();
}

class CustomQrLoaded extends CustomQrState {
  final List<Bank> banks; // Danh sách bank load từ API
  final QrInputModel inputModel; // Dữ liệu người dùng đang thao tác
  final String? qrPayload; // Chuỗi mã hóa QR (kết quả từ emv_qr_builder)

  const CustomQrLoaded({
    required this.banks,
    required this.inputModel,
    this.qrPayload,
  });

  // Helper để copyWith state dễ dàng (tương tự freezed nhưng viết tay cho sealed class)
  CustomQrLoaded copyWith({
    List<Bank>? banks,
    QrInputModel? inputModel,
    String? qrPayload,
  }) {
    return CustomQrLoaded(
      banks: banks ?? this.banks,
      inputModel: inputModel ?? this.inputModel,
      qrPayload: qrPayload ?? this.qrPayload,
    );
  }
}

class CustomQrError extends CustomQrState {
  final String message;
  const CustomQrError(this.message);
}
