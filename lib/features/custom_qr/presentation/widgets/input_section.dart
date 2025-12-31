import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:my_qr_cafe/core/enums/qr_type.dart';
import 'package:my_qr_cafe/features/custom_qr/cubit/custom_qr_cubit.dart';
import 'package:my_qr_cafe/features/custom_qr/cubit/custom_qr_state.dart';

class InputSection extends StatelessWidget {
  final CustomQrLoaded state;

  const InputSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomQrCubit>();
    final model = state.inputModel;

    return Column(
      children: [
        // 1. Loại QR Switch
        SegmentedButton<QrType>(
          segments: const [
            ButtonSegment(
              value: QrType.personal,
              label: Text('Cá Nhân'),
              icon: Icon(Icons.person),
            ),
            ButtonSegment(
              value: QrType.business,
              label: Text('Kinh Doanh'),
              icon: Icon(Icons.store),
            ),
          ],
          selected: {model.type},
          onSelectionChanged: (Set<QrType> newSelection) {
            cubit.updateInput(type: newSelection.first);
          },
        ),
        const Gap(16),

        // 2. Số tài khoản
        TextFormField(
          initialValue: model.accountNumber,
          decoration: const InputDecoration(
            labelText: 'Số tài khoản',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.credit_card),
          ),
          onChanged: (val) => cubit.updateInput(accountNumber: val),
        ),
        const Gap(12),

        // 3. Tên chủ tài khoản / Doanh nghiệp
        TextFormField(
          initialValue: model.merchantName,
          decoration: InputDecoration(
            labelText: model.type == QrType.personal
                ? 'Tên chủ thẻ (Tùy chọn)'
                : 'Tên doanh nghiệp (Hiển thị)',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.abc),
            helperText: "Nên viết in hoa không dấu",
          ),
          onChanged: (val) => cubit.updateInput(merchantName: val),
        ),
        const Gap(12),

        // 4. Số tiền
        TextFormField(
          initialValue: model.amount == 0
              ? ''
              : model.amount.toInt().toString(),
          decoration: const InputDecoration(
            labelText: 'Số tiền (VNĐ)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.attach_money),
            suffixText: 'VNĐ',
          ),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            final doubleAmount = double.tryParse(val) ?? 0;
            cubit.updateInput(amount: doubleAmount);
          },
        ),
      ],
    );
  }
}
