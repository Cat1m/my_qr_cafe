// lib/features/custom_qr/logic/custom_qr_cubit.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Import để dùng Color
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emv_qr_builder/emv_qr_builder.dart';
import 'package:my_qr_cafe/core/enums/qr_type.dart';
import 'package:my_qr_cafe/features/custom_qr/models/bank_model.dart';
import 'package:my_qr_cafe/features/custom_qr/models/qr_input_model/qr_input_model.dart';
import 'package:my_qr_cafe/features/custom_qr/repository/bank_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
          inputModel: const QrInputModel(), // Model đã có màu default
          qrPayload: null,
        ),
      );
    } catch (e) {
      emit(CustomQrError("Lỗi khởi tạo: $e"));
    }
  }

  // --- 2. UPDATE INPUT & COLOR ---

  // Hàm chọn ngân hàng
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

  // Hàm update text fields
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
            // Logic: Nếu giá trị mới (accountNumber) là null -> Giữ nguyên giá trị cũ
            accountNumber:
                accountNumber ?? currentState.inputModel.accountNumber,
            merchantName: merchantName ?? currentState.inputModel.merchantName,
            amount: amount ?? currentState.inputModel.amount,
            type: type ?? currentState.inputModel.type,
            mcc: mcc ?? currentState.inputModel.mcc,
            merchantCity: merchantCity ?? currentState.inputModel.merchantCity,
          ),
          qrPayload: null,
        ),
      );
    }
  }

  // [MỚI] Hàm update màu sắc
  void updateColor({Color? dataColor, Color? eyeColor, Color? bgColor}) {
    final currentState = state;
    if (currentState is CustomQrLoaded) {
      emit(
        currentState.copyWith(
          inputModel: currentState.inputModel.copyWith(
            // Nếu dataColor null (không truyền) thì freezed giữ nguyên giá trị cũ
            // Nếu truyền màu mới thì nó cập nhật
            dataColor: dataColor ?? currentState.inputModel.dataColor,
            eyeColor: eyeColor ?? currentState.inputModel.eyeColor,
            bgColor: bgColor ?? currentState.inputModel.bgColor,
          ),
          // Không cần reset qrPayload vì đổi màu chỉ là UI
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
          inputModel: currentState.inputModel.copyWith(
            // Trong freezed, truyền null vào field nullable sẽ set nó thành null
            logoBytes: null,
          ),
        ),
      );
    }
  }

  // --- 4. LOGIC TẠO QR (Generate) ---
  void generateQr({
    String? billNumber,
    String? storeId,
    String? terminalId,
    String? note,
  }) {
    final currentState = state;
    if (currentState is! CustomQrLoaded) return;

    final model = currentState.inputModel;

    if (model.selectedBank == null || model.accountNumber.isEmpty) {
      return;
    }

    // Ghép chuỗi Description
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

    // Lưu description vào model (để nếu user xoay màn hình không bị mất)
    // Chú ý: copyWith ở đây vẫn giữ nguyên các màu sắc đã chọn
    final updatedModel = model.copyWith(description: finalDescription);

    try {
      EmvData emvData;

      if (model.type == QrType.personal) {
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
        emvData = VietQrFactory.createBusiness(
          bankBin: model.selectedBank!.bin,
          accountNumber: model.accountNumber,
          merchantName: model.merchantName.isNotEmpty
              ? model.merchantName
              : 'BUSINESS',
          merchantCity: model.merchantCity,
          mcc: model.mcc,
          amount: model.amount > 0 ? model.amount.toInt().toString() : null,
          description: finalDescription.isNotEmpty ? finalDescription : null,
          billNumber: null,
          storeId: null,
          terminalId: null,
        );
      }

      final qrString = EmvBuilder.build(emvData);

      emit(
        currentState.copyWith(inputModel: updatedModel, qrPayload: qrString),
      );
    } catch (e) {
      if (kDebugMode) {
        print("Lỗi tạo QR: $e");
      }
      emit(CustomQrError("Không thể tạo mã QR: $e"));
    }
  }

  void updateShape({QrDataModuleShape? qrDataShape, QrEyeShape? qrEyeShape}) {
    final currentState = state;
    if (currentState is CustomQrLoaded) {
      emit(
        currentState.copyWith(
          inputModel: currentState.inputModel.copyWith(
            qrDataShape: qrDataShape ?? currentState.inputModel.qrDataShape,
            qrEyeShape: qrEyeShape ?? currentState.inputModel.qrEyeShape,
          ),
        ),
      );
    }
  }
}
