// lib/features/custom_qr/logic/custom_qr_cubit.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emv_qr_builder/emv_qr_builder.dart';
import 'package:my_qr_cafe/core/enums/qr_type.dart';
import 'package:my_qr_cafe/features/custom_qr/models/bank_model.dart';
import 'package:my_qr_cafe/features/custom_qr/models/qr_input_model/qr_input_model.dart';
import 'package:my_qr_cafe/features/custom_qr/repository/bank_repository.dart';
import 'custom_qr_state.dart';

class CustomQrCubit extends Cubit<CustomQrState> {
  final BankRepository _bankRepository;
  final ImagePicker _picker = ImagePicker();

  CustomQrCubit({required BankRepository bankRepository})
    : _bankRepository = bankRepository,
      super(const CustomQrInitial());

  // --- 1. KHỞI TẠO ---
  Future<void> init() async {
    emit(const CustomQrLoading());
    try {
      final banks = await _bankRepository.getBanks();
      emit(
        CustomQrLoaded(
          banks: banks,
          inputModel: const QrInputModel(),
          qrPayload: null,
        ),
      );
    } catch (e) {
      emit(CustomQrError("Lỗi khởi tạo: $e"));
    }
  }

  // --- 2. UPDATE INPUT ---
  void selectBank(Bank bank) {
    final currentState = state;
    if (currentState is CustomQrLoaded) {
      emit(
        currentState.copyWith(
          inputModel: currentState.inputModel.copyWith(selectedBank: bank),
          qrPayload: null,
        ),
      );
    }
  }

  void updateInput({
    String? accountNumber,
    String? merchantName,
    double? amount,
    QrType? type,
    String? mcc,
    String? merchantCity,
  }) {
    final currentState = state;
    if (currentState is CustomQrLoaded) {
      emit(
        currentState.copyWith(
          inputModel: currentState.inputModel.copyWith(
            accountNumber:
                accountNumber ?? currentState.inputModel.accountNumber,
            merchantName: merchantName ?? currentState.inputModel.merchantName,
            amount: amount ?? currentState.inputModel.amount,
            type: type ?? currentState.inputModel.type,
            mcc: mcc ?? currentState.inputModel.mcc,
            merchantCity: merchantCity ?? currentState.inputModel.merchantCity,
          ),
          qrPayload: null, // Reset QR khi data thay đổi
        ),
      );
    }
  }

  // --- 3. XỬ LÝ ẢNH ---
  Future<void> pickImage() async {
    final currentState = state;
    if (currentState is! CustomQrLoaded) return;

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final Uint8List bytes = await image.readAsBytes();
        emit(
          currentState.copyWith(
            inputModel: currentState.inputModel.copyWith(logoBytes: bytes),
          ),
        );
      }
    } catch (e) {
      // Handle error quietly
    }
  }

  void removeImage() {
    final currentState = state;
    if (currentState is CustomQrLoaded) {
      emit(
        currentState.copyWith(
          inputModel: currentState.inputModel.copyWith(logoBytes: null),
        ),
      );
    }
  }

  // --- 4. LOGIC TẠO QR (Generate) ---
  /// Hàm nhận các field rời rạc từ UI, ghép chuỗi và gọi Factory tương ứng
  void generateQr({
    String? billNumber,
    String? storeId,
    String? terminalId,
    String? note,
  }) {
    final currentState = state;
    if (currentState is! CustomQrLoaded) return;

    final model = currentState.inputModel;

    // Validate cơ bản
    if (model.selectedBank == null || model.accountNumber.isEmpty) {
      return;
    }

    // A. GHÉP CHUỖI DESCRIPTION (Chiến lược Small Business)
    // Format ví dụ: "BILL:123 STORE:ABC TER:XYZ NOTE:noidung"
    final List<String> parts = [];
    if (billNumber != null && billNumber.trim().isNotEmpty) {
      parts.add("BILL:${billNumber.trim()}");
    }
    if (storeId != null && storeId.trim().isNotEmpty) {
      parts.add("STORE:${storeId.trim()}");
    }
    if (terminalId != null && terminalId.trim().isNotEmpty) {
      parts.add("TER:${terminalId.trim()}");
    }
    if (note != null && note.trim().isNotEmpty) {
      parts.add(note.trim());
    }

    final String finalDescription = parts.join(' ');

    // Lưu lại description đã ghép vào model
    final updatedModel = model.copyWith(description: finalDescription);

    try {
      EmvData emvData;

      // B. SWITCH CASE: PERSONAL vs BUSINESS
      if (model.type == QrType.personal) {
        // --- CASE 1: PERSONAL ---
        emvData = VietQrFactory.createPersonal(
          bankBin: model.selectedBank!.bin,
          accountNumber: model.accountNumber,
          amount: model.amount > 0 ? model.amount.toInt().toString() : null,
          description: finalDescription.isNotEmpty ? finalDescription : null,
          accountName: model.merchantName.isNotEmpty
              ? model.merchantName
              : 'KHACH HANG',
        );
      } else {
        // --- CASE 2: BUSINESS ---
        emvData = VietQrFactory.createBusiness(
          bankBin: model.selectedBank!.bin,
          accountNumber: model.accountNumber,
          merchantName: model.merchantName.isNotEmpty
              ? model.merchantName
              : 'BUSINESS',
          merchantCity: model.merchantCity,
          mcc: model.mcc, // Mặc định 5999 hoặc user nhập
          amount: model.amount > 0 ? model.amount.toInt().toString() : null,

          // Ở đây ta đưa chuỗi đã ghép vào description (Field 62, ID 08)
          // Các trường billNumber, storeId, terminalId để null để đảm bảo
          // ngân hàng hiển thị nội dung description (theo docs của bạn).
          description: finalDescription.isNotEmpty ? finalDescription : null,
          billNumber: null,
          storeId: null,
          terminalId: null,
        );
      }

      // C. BUILD STRING PAYLOAD
      final qrString = EmvBuilder.build(emvData);

      // Emit kết quả
      emit(
        currentState.copyWith(inputModel: updatedModel, qrPayload: qrString),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi tạo QR: $e");
      }
      emit(CustomQrError("Không thể tạo mã QR: $e"));
      // Sau đó có thể emit lại Loaded để user không bị kẹt ở màn hình lỗi
    }
  }
}
