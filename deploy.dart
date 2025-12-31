// ignore_for_file: avoid_print

import 'dart:io';

// Hàm helper để in màu (nếu terminal hỗ trợ) hoặc in thường
void printLog(String message) {
  print('--------------------------------------------------');
  print('🚀 $message');
  print('--------------------------------------------------');
}

Future<void> main() async {
  final stopwatch = Stopwatch()..start();

  try {
    // --- BƯỚC 1: BUILD WASM ---
    printLog('Bắt đầu build Flutter Web (WASM)...');

    // Gọi lệnh flutter build
    // runInShell: true để đảm bảo chạy được trên Windows PowerShell/CMD
    final buildProcess = await Process.start(
      'flutter',
      ['build', 'web', '--wasm'],
      runInShell: true,
      mode: ProcessStartMode.inheritStdio, // In log build trực tiếp ra màn hình
    );

    final buildExitCode = await buildProcess.exitCode;
    if (buildExitCode != 0) {
      throw Exception('Lỗi khi build Flutter. Exit code: $buildExitCode');
    }

    // --- BƯỚC 2: COPY VERCEL.JSON ---
    printLog('Đang copy cấu hình vercel.json vào build/web...');

    final configFile = File('vercel.json');
    final targetDir = Directory('build/web');

    if (!await configFile.exists()) {
      throw Exception('Không tìm thấy file vercel.json ở thư mục gốc!');
    }

    if (!await targetDir.exists()) {
      throw Exception('Thư mục build/web không tồn tại. Có vẻ build thất bại?');
    }

    // Copy file (Dùng thư viện Dart IO nên chạy được cả Windows/Mac/Linux)
    await configFile.copy('${targetDir.path}/vercel.json');
    print('✅ Đã copy vercel.json thành công.');

    // --- BƯỚC 3: DEPLOY VERCEL ---
    printLog('Bắt đầu deploy lên Vercel Production...');

    // Chạy lệnh vercel deploy --prod ngay trong thư mục build/web
    final deployProcess = await Process.start(
      'vercel',
      ['deploy', '--prod'],
      workingDirectory: 'build/web', // Tương đương lệnh cd build/web
      runInShell: true,
      mode: ProcessStartMode.inheritStdio,
    );

    final deployExitCode = await deployProcess.exitCode;
    if (deployExitCode != 0) {
      throw Exception('Lỗi khi deploy Vercel. Exit code: $deployExitCode');
    }

    stopwatch.stop();
    printLog(
      '🎉 HOÀN TẤT! Tổng thời gian: ${stopwatch.elapsed.inSeconds} giây.',
    );
    print('👉 Kiểm tra tại dashboard: https://vercel.com/dashboard');
  } catch (e) {
    print('\n❌ CÓ LỖI XẢY RA: $e');
    exit(1); // Thoát với mã lỗi
  }
}
