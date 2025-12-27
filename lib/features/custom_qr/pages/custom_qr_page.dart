import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:emv_qr_builder/emv_qr_builder.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/qr_info_model.dart';

class CustomQrPage extends StatefulWidget {
  const CustomQrPage({super.key});

  @override
  State<CustomQrPage> createState() => _CustomQrPageState();
}

class _CustomQrPageState extends State<CustomQrPage> {
  // State quản lý bằng Freezed Model (optional, hoặc dùng biến rời cũng được)
  String _selectedBin = AppConstants.banks.first['bin']!;
  final TextEditingController _accNumController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String _qrData = '';

  void _generateQr() {
    if (_accNumController.text.isEmpty) return;

    String amountRaw = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Sử dụng Model để quản lý data (Ví dụ cách dùng)
    final inputModel = QrInfoModel(
      bankBin: _selectedBin,
      accountNumber: _accNumController.text,
      amount: amountRaw.isEmpty ? null : amountRaw,
      description: _contentController.text,
    );

    final emvData = VietQrFactory.createPersonal(
      bankBin: inputModel.bankBin,
      accountNumber: inputModel.accountNumber,
      amount: inputModel.amount,
      description: inputModel.description,
    );

    setState(() {
      _qrData = EmvBuilder.build(emvData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.qr_code_scanner,
                      size: 48,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tạo QR Của Bạn',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 1. Chọn Ngân Hàng
                    DropdownButtonFormField<String>(
                      initialValue: _selectedBin,
                      decoration: const InputDecoration(
                        labelText: 'Ngân hàng',
                        border: OutlineInputBorder(),
                      ),
                      items: AppConstants.banks.map((bank) {
                        return DropdownMenuItem(
                          value: bank['bin'],
                          child: Text(bank['name']!),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => _selectedBin = val!);
                        _generateQr();
                      },
                    ),
                    const SizedBox(height: 16),

                    // 2. Nhập số tài khoản
                    TextField(
                      controller: _accNumController,
                      decoration: const InputDecoration(
                        labelText: 'Số tài khoản',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _generateQr(),
                    ),
                    const SizedBox(height: 16),

                    // 3. Số tiền & Nội dung (Giống feature cũ)
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Số tiền (VND)',
                        suffixText: 'đ',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _generateQr(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Nội dung',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _generateQr(),
                    ),

                    const SizedBox(height: 30),

                    // Render QR
                    if (_qrData.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: QrImageView(
                          data: _qrData,
                          size: 200,
                          version: QrVersions.auto,
                        ),
                      )
                    else
                      const Text(
                        "Nhập thông tin để tạo mã",
                        style: TextStyle(color: Colors.grey),
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
}
