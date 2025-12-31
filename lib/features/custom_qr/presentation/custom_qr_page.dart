// lib/features/custom_qr/presentation/custom_qr_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_qr_cafe/features/custom_qr/cubit/custom_qr_cubit.dart';
import 'package:my_qr_cafe/features/custom_qr/presentation/custom_qr_view.dart';
import 'package:my_qr_cafe/features/custom_qr/repository/bank_repository.dart';

class CustomQrPage extends StatelessWidget {
  const CustomQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomQrCubit(
        bankRepository: RepositoryProvider.of<BankRepository>(
          context,
        ), // Hoặc khởi tạo trực tiếp nếu chưa có DI global
      )..init(),
      child: const CustomQrView(),
    );
  }
}
