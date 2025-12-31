import 'dart:js_interop' as web;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Import chuẩn cho Flutter Web mới
import 'package:web/web.dart' as web;
import 'dart:js_interop';

class ImageHelper {
  /// 1. Chụp Widget (Giữ nguyên)
  static Future<Uint8List?> captureWidget(GlobalKey key) async {
    try {
      final boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Lỗi capture: $e");
      return null;
    }
  }

  /// 2. Lưu ảnh (Giữ nguyên - đã chạy ổn)
  static Future<void> saveImage(
    Uint8List bytes, {
    String fileName = "vietqr_code.png",
  }) async {
    final blob = web.Blob(
      [bytes.toJS].toJS,
      web.BlobPropertyBag(type: 'image/png'),
    );
    final url = web.URL.createObjectURL(blob);
    // ignore: unused_local_variable
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..download = fileName
      ..click();
    web.URL.revokeObjectURL(url);
  }

  /// 3. Copy ảnh (Đã FIX lỗi JSAny -> JSObject)
  static Future<void> copyImage(Uint8List bytes) async {
    try {
      // B1: Tạo Blob
      final blob = web.Blob(
        [bytes.toJS].toJS,
        web.BlobPropertyBag(type: 'image/png'),
      );

      // B2: Tạo JS Object { "image/png": blob }
      // FIX LỖI Ở ĐÂY: .jsify() trả về JSAny?, ta cần ép kiểu 'as web.JSObject'
      // vì constructor ClipboardItem(JSObject items) yêu cầu chính xác JSObject.
      final dataMap = {'image/png': blob}.jsify() as web.JSObject;

      // B3: Tạo ClipboardItem
      final clipboardItem = web.ClipboardItem(dataMap);

      // B4: Gọi API write
      // [clipboardItem].toJS tạo ra một JSArray<ClipboardItem>
      await web.window.navigator.clipboard.write([clipboardItem].toJS).toDart;
    } catch (e) {
      debugPrint("Lỗi Copy: $e");
      throw Exception(
        "Không thể copy. Đảm bảo bạn đang chạy trên HTTPS hoặc Localhost.",
      );
    }
  }
}
