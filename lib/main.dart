import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:emv_qr_builder/emv_qr_builder.dart';

void main() {
  runApp(const MyQrCafeApp());
}

class MyQrCafeApp extends StatelessWidget {
  const MyQrCafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My QR Cafe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const PaymentPage(),
    );
  }
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Thông tin cứng của bạn (Techcombank)
  final String _bankBin = '970407';
  final String _accountNumber = '19033804311013';
  final String _accountName =
      'KHACH HANG'; // Có thể sửa thành tên bạn nếu thích

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _contentController = TextEditingController(
    text: 'Tien Cafe',
  );

  String _qrData = '';

  @override
  void initState() {
    super.initState();
    _generateQr(); // Tạo QR mặc định lúc mở app
  }

  void _generateQr() {
    // 1. Lấy dữ liệu từ input
    // Xóa dấu chấm phẩy nếu có để đảm bảo là số nguyên
    String amountRaw = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    String content = _contentController.text;

    // 2. Dùng package của BẠN để tạo payload
    final emvData = VietQrFactory.createPersonal(
      bankBin: _bankBin,
      accountNumber: _accountNumber,
      accountName: _accountName,
      amount: amountRaw.isEmpty ? null : amountRaw, // Nếu rỗng thì tạo QR tĩnh
      description: content,
    );

    // 3. Build ra chuỗi String
    setState(() {
      _qrData = EmvBuilder.build(emvData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                width: 400, // Giới hạn chiều rộng cho đẹp trên Web
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.coffee, size: 48, color: Colors.brown),
                    const SizedBox(height: 10),
                    const Text(
                      'Mời tôi ly Cafe nhé! ☕️',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Techcombank: $_accountNumber',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 30),

                    // --- KHUNG QR CODE ---
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: QrImageView(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- INPUT SỐ TIỀN ---
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Số tiền (VND)',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                        suffixText: 'đ',
                      ),
                      onChanged: (_) =>
                          _generateQr(), // Tự động render lại khi gõ
                    ),
                    const SizedBox(height: 16),

                    // --- INPUT NỘI DUNG ---
                    TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Lời nhắn',
                        prefixIcon: Icon(Icons.message_outlined),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _generateQr(),
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      'Package: emv_qr_builder',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
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
