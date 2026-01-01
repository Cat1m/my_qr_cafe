import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để dùng tính năng Copy text
import 'package:gap/gap.dart'; // Dùng Gap cho tiện giống project của bạn

import 'package:emv_qr_builder/emv_qr_builder.dart';
import 'package:qr_flutter/qr_flutter.dart';

// [QUAN TRỌNG] Đảm bảo import đúng đường dẫn ImageHelper trong project của bạn
import '../../../../core/utils/image_helper.dart';

class MyQrPage extends StatefulWidget {
  const MyQrPage({super.key});

  @override
  State<MyQrPage> createState() => _MyQrPageState();
}

class _MyQrPageState extends State<MyQrPage> {
  // --- CẤU HÌNH CỨNG ---
  final String _bankBin = '970407'; // Techcombank
  final String _accountNumber = '19033804311013';
  final String _accountName = 'LE MINH CHIEN';

  // --- STATE QUẢN LÝ ---
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _contentController = TextEditingController(
    text: 'XIN CAM ON',
  );

  String _qrData = '';

  // [MỚI] Key để chụp ảnh QR
  final GlobalKey _qrKey = GlobalKey();
  // [MỚI] Trạng thái loading khi đang lưu/copy
  bool _isProcessing = false;

  // Màu chủ đạo (Coffee theme)
  final Color _primaryColor = const Color(0xFF6D4C41); // Brown 600
  final Color _backgroundColor = const Color(0xFFFAFAFA); // Grey 50

  @override
  void initState() {
    super.initState();
    _generateQr();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _generateQr() {
    String amountRaw = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');

    final emvData = VietQrFactory.createPersonal(
      bankBin: _bankBin,
      accountNumber: _accountNumber,
      accountName: _accountName,
      amount: amountRaw.isEmpty ? null : amountRaw,
      description: _contentController.text,
    );

    setState(() {
      _qrData = EmvBuilder.build(emvData);
    });
  }

  void _setAmount(String value) {
    _amountController.text = value;
    _generateQr();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _accountNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đã sao chép số tài khoản!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _primaryColor,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // --- [MỚI] XỬ LÝ LƯU ẢNH ---
  Future<void> _handleSave() async {
    setState(() => _isProcessing = true);
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final bytes = await ImageHelper.captureWidget(_qrKey);
      if (bytes != null) {
        final fileName =
            "my_coffee_qr_${DateTime.now().millisecondsSinceEpoch}.png";
        await ImageHelper.saveImage(bytes, fileName: fileName);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Đã tải ảnh về máy!"),
              backgroundColor: _primaryColor,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Err: $e");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  // --- [MỚI] XỬ LÝ COPY ẢNH ---
  Future<void> _handleCopy() async {
    setState(() => _isProcessing = true);
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final bytes = await ImageHelper.captureWidget(_qrKey);
      if (bytes != null) {
        await ImageHelper.copyImage(bytes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Đã copy ảnh QR!"),
              backgroundColor: _primaryColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Lỗi copy (Cần HTTPS/Localhost)"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- HEADER ---
                    Icon(Icons.coffee_rounded, size: 40, color: _primaryColor),
                    const SizedBox(height: 16),
                    Text(
                      "Buy me a Coffee",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // --- BANK INFO ---
                    InkWell(
                      onTap: _copyToClipboard,
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Techcombank • $_accountNumber",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.copy_rounded,
                              size: 14,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --- QR CODE AREA [MỚI: Bọc RepaintBoundary] ---
                    RepaintBoundary(
                      key: _qrKey,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: _primaryColor.withOpacity(
                                0.08,
                              ), // Fix cho bản cũ/mới
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            QrImageView(
                              data: _qrData,
                              version: QrVersions.auto,
                              size: 200.0,
                              backgroundColor: Colors.white,
                              errorCorrectionLevel: QrErrorCorrectLevel.M,
                              gapless: false,
                              eyeStyle: QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: _primaryColor,
                              ),
                              dataModuleStyle: QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.circle,
                                color: Colors.grey[800],
                              ),
                            ),
                            const Gap(8),
                            // Thêm tên chủ TK vào ảnh QR luôn để người ck yên tâm
                            Text(
                              _accountName,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- [MỚI] BUTTONS LƯU/COPY ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildActionButton(
                          icon: Icons.download_rounded,
                          label: "Lưu",
                          onTap: _isProcessing ? null : _handleSave,
                        ),
                        const SizedBox(width: 16),
                        _buildActionButton(
                          icon: Icons.copy_rounded,
                          label: "Copy",
                          onTap: _isProcessing ? null : _handleCopy,
                          isOutlined: true,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // --- INPUT SỐ TIỀN ---
                    _buildMinimalInput(
                      controller: _amountController,
                      label: "Số tiền",
                      suffix: "VND",
                      isNumber: true,
                      icon: Icons.attach_money_rounded,
                    ),

                    const SizedBox(height: 12),

                    // --- QUICK ACTION CHIPS ---
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildQuickAmountChip('20,000'),
                          const SizedBox(width: 8),
                          _buildQuickAmountChip('50,000'),
                          const SizedBox(width: 8),
                          _buildQuickAmountChip('100,000'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- INPUT LỜI NHẮN ---
                    _buildMinimalInput(
                      controller: _contentController,
                      label: "Lời nhắn",
                      icon: Icons.message_outlined,
                    ),

                    const SizedBox(height: 20),

                    // --- FOOTER ---
                    Text(
                      "Cảm ơn bạn đã ủng hộ! ❤️",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // [MỚI] Helper Button nhỏ gọn phù hợp style Coffee
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool isOutlined = false,
  }) {
    final color = _primaryColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: isOutlined ? Colors.transparent : color.withOpacity(0.1),
          border: Border.all(
            color: isOutlined ? Colors.grey.shade300 : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isProcessing)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: color),
              )
            else
              Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalInput({
    required TextEditingController controller,
    required String label,
    String? suffix,
    bool isNumber = false,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _primaryColor,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.grey[400], size: 20),
          hintText: label,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontWeight: FontWeight.normal,
          ),
          suffixText: suffix,
          suffixStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        onChanged: (_) => _generateQr(),
      ),
    );
  }

  Widget _buildQuickAmountChip(String label) {
    final valueRaw = label.replaceAll(',', '');
    final isSelected = _amountController.text == valueRaw;

    return InkWell(
      onTap: () => _setAmount(valueRaw),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? _primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}
