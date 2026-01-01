import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorSelector extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const ColorSelector({
    super.key,
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: InkWell(
        onTap: () => _showColorPickerDialog(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 2),
            boxShadow: [
              BoxShadow(
                // Dùng .withValues(alpha: ...) cho Flutter 3.27+ hoặc .withOpacity(...) cho bản cũ
                color: color.withValues(alpha: .4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context) {
    // Biến tạm để lưu màu (chỉ dùng khi bấm nút Chọn)
    Color tempColor = color;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Chọn $label'),
          content: SingleChildScrollView(
            // [FIX] Bỏ StatefulBuilder để tránh reset Hue khi màu là Đen/Trắng
            child: ColorPicker(
              pickerColor: color, // Chỉ nạp màu khởi tạo 1 lần duy nhất
              onColorChanged: (newColor) {
                // Chỉ lưu giá trị, không gọi setState của cha để tránh Rebuild widget
                tempColor = newColor;
              },

              // --- CÁC TÙY CHỌN HIỂN THỊ ---
              enableAlpha: false,
              displayThumbColor: true,
              paletteType: PaletteType.hsvWithHue,
              pickerAreaHeightPercent: 0.7,
              hexInputBar:
                  true, // Thanh nhập Hex vẫn hoạt động tốt do ColorPicker tự quản lý
              portraitOnly: true,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Hủy'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Chọn'),
              onPressed: () {
                onColorChanged(tempColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
