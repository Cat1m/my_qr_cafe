import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DescriptionInputs extends StatelessWidget {
  final TextEditingController billCtrl;
  final TextEditingController storeCtrl;
  final TextEditingController terminalCtrl;
  final TextEditingController noteCtrl;

  const DescriptionInputs({
    super.key,
    required this.billCtrl,
    required this.storeCtrl,
    required this.terminalCtrl,
    required this.noteCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nội dung chuyển khoản (Ghép chuỗi)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              "Các thông tin dưới đây sẽ được nối lại để hiển thị trong app ngân hàng.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: billCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Bill Number',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: TextField(
                    controller: storeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Store ID',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: terminalCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Terminal ID',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: TextField(
                    controller: noteCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Ghi chú',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
