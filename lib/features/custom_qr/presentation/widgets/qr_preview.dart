import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:my_qr_cafe/features/custom_qr/cubit/custom_qr_cubit.dart';
import 'package:my_qr_cafe/features/custom_qr/cubit/custom_qr_state.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/utils/image_helper.dart';

class QrPreview extends StatefulWidget {
  final CustomQrLoaded state;
  const QrPreview({super.key, required this.state});

  @override
  State<QrPreview> createState() => _QrPreviewState();
}

class _QrPreviewState extends State<QrPreview> {
  // Key 1: Chụp toàn bộ thẻ (Background + Text + QR)
  final GlobalKey _fullCardKey = GlobalKey();

  // Key 2: Chỉ chụp riêng vùng QR (Nền trong suốt)
  final GlobalKey _qrOnlyKey = GlobalKey();

  bool _isProcessing = false;

  // Biến Toggle: false = Full Card (Mặc định), true = Chỉ QR
  bool _saveOnlyQr = false;

  /// Xử lý lấy Key phù hợp dựa trên lựa chọn
  GlobalKey get _currentKey => _saveOnlyQr ? _qrOnlyKey : _fullCardKey;

  /// Xử lý lưu ảnh
  Future<void> _handleSave() async {
    setState(() => _isProcessing = true);
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      // Chụp widget dựa trên key đang chọn
      final bytes = await ImageHelper.captureWidget(_currentKey);

      if (bytes != null) {
        final prefix = _saveOnlyQr ? "vietqr_transparent_" : "vietqr_full_";
        final fileName = "$prefix${DateTime.now().millisecondsSinceEpoch}.png";

        await ImageHelper.saveImage(bytes, fileName: fileName);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _saveOnlyQr ? "Đã tải QR tách nền!" : "Đã tải ảnh đầy đủ!",
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  /// Xử lý copy ảnh
  Future<void> _handleCopy() async {
    setState(() => _isProcessing = true);
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final bytes = await ImageHelper.captureWidget(_currentKey);

      if (bytes != null) {
        await ImageHelper.copyImage(bytes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _saveOnlyQr
                    ? "Đã copy QR (nền trong suốt)!"
                    : "Đã copy ảnh đầy đủ!",
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Không thể copy (cần HTTPS hoặc Localhost)."),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.state.inputModel;
    final qrData = widget.state.qrPayload;
    final logoBytes = model.logoBytes;

    final bgColor = model.bgColor;
    final dataColor = model.dataColor;
    final eyeColor = model.eyeColor;
    final eyeShape = model.qrEyeShape;
    final dataShape = model.qrDataShape;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- 1. VÙNG HIỂN THỊ (PREVIEW) ---
        // RepaintBoundary 1: Bao bọc toàn bộ thẻ (Full Card)
        RepaintBoundary(
          key: _fullCardKey,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // Flutter 3.27+ dùng withValues, bản cũ dùng withOpacity
                  color: Colors.black.withValues(alpha: .1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: qrData == null
                ? const SizedBox(
                    height: 280,
                    width: 280,
                    child: Center(
                      child: Text(
                        "Nhập thông tin...",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Quét mã để thanh toán",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Gap(16),

                      // --- QR STACK ---
                      // RepaintBoundary 2: Chỉ bao bọc vùng QR (Transparent QR)
                      RepaintBoundary(
                        key: _qrOnlyKey,
                        child: SizedBox(
                          width: 280,
                          height: 280,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              QrImageView(
                                data: qrData,
                                version: QrVersions.auto,
                                size: 280,
                                errorCorrectionLevel: QrErrorCorrectLevel.H,
                                // Nền trong suốt để khi lưu mode 2 sẽ không có nền
                                backgroundColor: Colors.transparent,
                                gapless: false,

                                eyeStyle: QrEyeStyle(
                                  eyeShape: eyeShape,
                                  color: eyeColor,
                                ),
                                dataModuleStyle: QrDataModuleStyle(
                                  dataModuleShape: dataShape,
                                  color: dataColor,
                                ),
                              ),

                              // Logo Layer
                              if (logoBytes != null) ...[
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color:
                                        bgColor, // Vẫn cần màu nền này để che các chấm QR bên dưới logo
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    logoBytes,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      // --- END QR STACK ---
                      const Gap(16),
                      Text(
                        model.merchantName.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        const Gap(24),

        // --- 2. SWITCH CHỌN CHẾ ĐỘ ---
        if (qrData != null)
          Container(
            width: 300, // Giới hạn chiều rộng cho đẹp
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _saveOnlyQr ? "Chỉ lưu QR (Trong suốt)" : "Lưu toàn bộ thẻ",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Switch(
                  value: _saveOnlyQr,
                  onChanged: (val) {
                    setState(() => _saveOnlyQr = val);
                  },
                  activeThumbColor: Colors.blue,
                ),
              ],
            ),
          ),

        // --- 3. CÁC NÚT BẤM CHỨC NĂNG ---
        if (qrData != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isProcessing ? null : _handleSave,
                icon: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download),
                label: Text(_saveOnlyQr ? "Tải QR" : "Tải ảnh"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
              const Gap(12),
              OutlinedButton.icon(
                onPressed: _isProcessing ? null : _handleCopy,
                icon: const Icon(Icons.copy),
                label: const Text("Sao chép"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],

        const Gap(24),

        // Nút thêm Logo
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => context.read<CustomQrCubit>().pickImage(),
              icon: const Icon(Icons.image),
              label: Text(logoBytes == null ? "Thêm Logo" : "Đổi Logo"),
            ),
            if (logoBytes != null) ...[
              const Gap(8),
              IconButton(
                onPressed: () => context.read<CustomQrCubit>().removeImage(),
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: "Xóa logo",
              ),
            ],
          ],
        ),
      ],
    );
  }
}
