// lib/features/custom_qr/presentation/custom_qr_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:my_qr_cafe/features/custom_qr/cubit/custom_qr_cubit.dart';
import 'package:my_qr_cafe/features/custom_qr/cubit/custom_qr_state.dart';
import 'package:my_qr_cafe/features/custom_qr/presentation/widgets/bank_selector.dart';
import 'package:my_qr_cafe/features/custom_qr/presentation/widgets/description_inputs.dart';
import 'package:my_qr_cafe/features/custom_qr/presentation/widgets/input_section.dart';
import 'package:my_qr_cafe/features/custom_qr/presentation/widgets/qr_preview.dart';

class CustomQrView extends StatefulWidget {
  const CustomQrView({super.key});

  @override
  State<CustomQrView> createState() => _CustomQrViewState();
}

class _CustomQrViewState extends State<CustomQrView> {
  // Controller cho các trường sẽ được ghép chuỗi (Description)
  final _billCtrl = TextEditingController();
  final _storeCtrl = TextEditingController();
  final _terminalCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _billCtrl.dispose();
    _storeCtrl.dispose();
    _terminalCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tạo VietQR Custom')),
      body: BlocConsumer<CustomQrCubit, CustomQrState>(
        listener: (context, state) {
          if (state is CustomQrError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CustomQrLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CustomQrLoaded) {
            // Layout chia đôi: Web (Row) hoặc Mobile (Column)
            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;

                final inputPanel = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BankSelector(
                      banks: state.banks,
                      selectedBank: state.inputModel.selectedBank,
                      onChanged: (bank) =>
                          context.read<CustomQrCubit>().selectBank(bank!),
                    ),
                    const Gap(16),
                    InputSection(state: state),
                    const Gap(16),
                    // Khu vực nhập các trường phụ để ghép chuỗi
                    DescriptionInputs(
                      billCtrl: _billCtrl,
                      storeCtrl: _storeCtrl,
                      terminalCtrl: _terminalCtrl,
                      noteCtrl: _noteCtrl,
                    ),
                    const Gap(24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.qr_code),
                        label: const Text("TẠO MÃ QR"),
                        onPressed: () {
                          // Gọi hàm generate và truyền các giá trị text field vào để ghép chuỗi
                          context.read<CustomQrCubit>().generateQr(
                            billNumber: _billCtrl.text,
                            storeId: _storeCtrl.text,
                            terminalId: _terminalCtrl.text,
                            note: _noteCtrl.text,
                          );
                        },
                      ),
                    ),
                    const Gap(32),
                  ],
                );

                final previewPanel = Center(child: QrPreview(state: state));

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: inputPanel,
                        ),
                      ),
                      Container(width: 1, color: Colors.grey.shade300),
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: previewPanel,
                        ),
                      ),
                    ],
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      inputPanel,
                      const Divider(height: 48),
                      previewPanel,
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
