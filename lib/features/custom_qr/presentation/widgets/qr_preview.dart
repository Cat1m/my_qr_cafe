import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_qr_cafe/features/custom_qr/cubit/custom_qr_cubit.dart';
import 'package:my_qr_cafe/features/custom_qr/cubit/custom_qr_state.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/utils/image_helper.dart';

class QrPreview extends StatefulWidget {
  final CustomQrLoaded state;

  const QrPreview({super.key, required this.state});

  @override
  State<QrPreview> createState() => _QrPreviewState();
}

class _QrPreviewState extends State<QrPreview> {
  // Key dùng để chụp ảnh widget (RepaintBoundary)
  final GlobalKey _qrKey = GlobalKey();

  // Biến trạng thái loading cho nút bấm
  bool _isProcessing = false;

  /// Xử lý sự kiện Lưu ảnh
  Future<void> _handleSave() async {
    setState(() => _isProcessing = true);
    try {
      // Delay nhẹ để UI kịp render trạng thái loading trước khi chụp
      await Future.delayed(const Duration(milliseconds: 100));

      final bytes = await ImageHelper.captureWidget(_qrKey);
      if (bytes != null) {
        // Tạo tên file unique theo thời gian
        final fileName = "vietqr_${DateTime.now().millisecondsSinceEpoch}.png";

        await ImageHelper.saveImage(bytes, fileName: fileName);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Đang tải ảnh xuống..."),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Lỗi lưu ảnh: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  /// Xử lý sự kiện Copy ảnh
  Future<void> _handleCopy() async {
    setState(() => _isProcessing = true);
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final bytes = await ImageHelper.captureWidget(_qrKey);
      if (bytes != null) {
        await ImageHelper.copyImage(bytes);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Đã sao chép ảnh! Bạn có thể dán (Ctrl+V) ngay."),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // Lưu ý: Copy chỉ hoạt động trên HTTPS hoặc Localhost
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Không thể copy. Hãy kiểm tra quyền hoặc HTTPS."),
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
    final qrData = widget.state.qrPayload;
    final logoBytes = widget.state.inputModel.logoBytes;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Khu vực QR Code (Được bọc RepaintBoundary để chụp)
        RepaintBoundary(
          key: _qrKey,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // Bắt buộc màu trắng để ảnh chụp đẹp
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: qrData == null
                ? const SizedBox(
                    height: 250,
                    width: 250,
                    child: Center(
                      child: Text(
                        "Nhập thông tin và bấm\n'TẠO MÃ QR'",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tiêu đề
                      const Text(
                        "Quét mã để thanh toán",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const Gap(8),

                      // QR Image từ thư viện qr_flutter
                      QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 280,
                        backgroundColor: Colors.white,
                        // Ảnh logo ở giữa (nếu có)
                        embeddedImage: logoBytes != null
                            ? MemoryImage(logoBytes)
                            : null,
                        embeddedImageStyle: const QrEmbeddedImageStyle(
                          size: Size(50, 50),
                        ),
                      ),
                      const Gap(8),

                      // Tên chủ TK hiển thị bên dưới
                      Text(
                        widget.state.inputModel.merchantName.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),

        const Gap(24),

        // 2. Khu vực Nút bấm (Chỉ hiện khi đã có QR)
        if (qrData != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nút Save
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
                label: const Text("Tải ảnh về"),
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

              // Nút Copy
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

        const Gap(24),

        // 3. Nút Chọn/Đổi Logo
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => context.read<CustomQrCubit>().pickImage(),
              icon: const Icon(Icons.image),
              label: Text(
                logoBytes == null ? "Thêm Logo (Giữa QR)" : "Đổi Logo",
              ),
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

        // 4. Debug info (Ẩn trong ExpansionTile cho gọn)
        if (qrData != null) ...[
          const Gap(16),
          ExpansionTile(
            title: const Text(
              "Xem nội dung chuỗi (Debug)",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            children: [
              SelectableText(
                qrData,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
