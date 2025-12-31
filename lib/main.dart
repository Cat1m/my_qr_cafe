import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 1. Import thư viện bloc
import 'package:my_qr_cafe/features/custom_qr/repository/bank_repository.dart';

import 'features/my_qr/pages/my_qr_page.dart';
import 'features/custom_qr/presentation/custom_qr_page.dart';

void main() {
  runApp(const MyQrCafeApp());
}

class MyQrCafeApp extends StatelessWidget {
  const MyQrCafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Bọc MaterialApp bằng RepositoryProvider
    return RepositoryProvider(
      create: (context) => BankRepository(),
      child: MaterialApp(
        title: 'My QR Cafe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
          useMaterial3: true,
        ),
        home: const MainContainer(),
      ),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [MyQrPage(), CustomQrPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.coffee), label: 'QR Admin'),
          NavigationDestination(
            icon: Icon(Icons.qr_code_2),
            label: 'Tạo QR Tùy chỉnh',
          ),
        ],
      ),
    );
  }
}
