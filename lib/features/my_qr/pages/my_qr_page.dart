import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để dùng tính năng Copy

import 'package:emv_qr_builder/emv_qr_builder.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrPage extends StatefulWidget {
  const MyQrPage({super.key});

  @override
  State<MyQrPage> createState() => _MyQrPageState();
}

class _MyQrPageState extends State<MyQrPage> {
  // --- CẤU HÌNH CỨNG (Thông tin của bạn) ---
  final String _bankBin = '970407'; // Techcombank
  final String _accountNumber = '19033804311013';
  final String _accountName = 'KHACH HANG'; // Tên chủ tài khoản

  // --- STATE QUẢN LÝ ---
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _contentController = TextEditingController(
    text: 'Cafe',
  );

  String _qrData = '';

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
    // Xử lý số tiền: xóa ký tự không phải số
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

  // Helper chọn nhanh số tiền
  void _setAmount(String value) {
    _amountController.text = value;
    _generateQr();
  }

  // Helper copy số tài khoản
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ), // Giới hạn chiều rộng cho Web
            child: Card(
              elevation: 0, // Bỏ shadow mặc định đậm đà
              // Tạo shadow thủ công mềm mại hơn
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

                    // --- BANK INFO (Minimal Row) ---
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

                    // --- QR CODE AREA ---
                    // Sử dụng Stack để trang trí nhẹ hoặc bo góc QR
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryColor.withValues(alpha: .08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                        // Custom mắt QR cho đẹp (Optional)
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: _primaryColor,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // --- INPUT SỐ TIỀN (Big & Clean) ---
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

  // Widget con: Input theo style tối giản
  Widget _buildMinimalInput({
    required TextEditingController controller,
    required String label,
    String? suffix,
    bool isNumber = false,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50], // Nền xám rất nhạt
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
          border: InputBorder.none, // Bỏ viền
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

  // Widget con: Chip chọn tiền nhanh
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
