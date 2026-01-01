import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:my_qr_cafe/core/enums/qr_type.dart';
import 'package:my_qr_cafe/features/custom_qr/cubit/custom_qr_cubit.dart';
import 'package:my_qr_cafe/features/custom_qr/cubit/custom_qr_state.dart';
// Đừng quên import widget chọn màu này nhé!
import 'package:my_qr_cafe/features/custom_qr/presentation/widgets/color_selector.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InputSection extends StatefulWidget {
  final CustomQrLoaded state;

  const InputSection({super.key, required this.state});

  @override
  State<InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends State<InputSection> {
  late TextEditingController _amountController;

  final List<double> _suggestedAmounts = [20000, 50000, 100000, 200000, 500000];

  @override
  void initState() {
    super.initState();
    final initialAmount = widget.state.inputModel.amount;
    _amountController = TextEditingController(
      text: initialAmount == 0 ? '' : initialAmount.toInt().toString(),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String _formatLabel(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toInt()}k';
    }
    return amount.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CustomQrCubit>();
    final model = widget.state.inputModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Loại QR Switch
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<QrType>(
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

        // 3. Tên chủ tài khoản
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
          controller: _amountController,
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

        const Gap(8),

        // 5. Gợi ý mệnh giá
        Text(
          'Gợi ý nhanh:',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        const Gap(4),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: _suggestedAmounts.map((amount) {
            final isSelected = model.amount == amount;
            return ChoiceChip(
              label: Text(_formatLabel(amount)),
              selected: isSelected,
              onSelected: (bool selected) {
                final newValue = selected ? amount : 0.0;
                _amountController.text = newValue == 0
                    ? ''
                    : newValue.toInt().toString();
                cubit.updateInput(amount: newValue);
              },
            );
          }).toList(),
        ),

        const Gap(24),

        // --- 6. TÙY CHỈNH GIAO DIỆN (MÀU SẮC & HÌNH DÁNG) ---
        ExpansionTile(
          title: const Text("Tùy chỉnh giao diện QR"),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- [MỚI] CHỌN HÌNH DÁNG MẮT (EYE) ---
                  const Text(
                    "Hình dáng Mắt QR:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Gap(8),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<QrEyeShape>(
                      segments: const [
                        ButtonSegment(
                          value: QrEyeShape.square,
                          label: Text('Vuông'),
                          icon: Icon(Icons.crop_square),
                        ),
                        ButtonSegment(
                          value: QrEyeShape.circle,
                          label: Text('Tròn'),
                          icon: Icon(Icons.circle_outlined),
                        ),
                      ],
                      selected: {model.qrEyeShape},
                      onSelectionChanged: (Set<QrEyeShape> newSelection) {
                        cubit.updateShape(qrEyeShape: newSelection.first);
                      },
                    ),
                  ),
                  const Gap(16),

                  // --- [MỚI] CHỌN HÌNH DÁNG CHẤM (DATA) ---
                  const Text(
                    "Hình dáng Chấm dữ liệu:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Gap(8),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<QrDataModuleShape>(
                      segments: const [
                        ButtonSegment(
                          value: QrDataModuleShape.square,
                          label: Text('Vuông'),
                          icon: Icon(Icons.apps),
                        ),
                        ButtonSegment(
                          value: QrDataModuleShape.circle,
                          label: Text('Tròn'),
                          icon: Icon(Icons.grain),
                        ),
                      ],
                      selected: {model.qrDataShape},
                      onSelectionChanged:
                          (Set<QrDataModuleShape> newSelection) {
                            cubit.updateShape(qrDataShape: newSelection.first);
                          },
                    ),
                  ),

                  const Divider(height: 32),

                  // --- PHẦN CHỌN MÀU CŨ ---
                  ColorSelector(
                    label: "Màu mắt QR (Góc)",
                    color: model.eyeColor,
                    onColorChanged: (c) => cubit.updateColor(eyeColor: c),
                  ),
                  const Divider(height: 1),
                  ColorSelector(
                    label: "Màu chấm dữ liệu",
                    color: model.dataColor,
                    onColorChanged: (c) => cubit.updateColor(dataColor: c),
                  ),
                  const Divider(height: 1),
                  ColorSelector(
                    label: "Màu nền thẻ",
                    color: model.bgColor,
                    onColorChanged: (c) => cubit.updateColor(bgColor: c),
                  ),
                  const Gap(16),
                ],
              ),
            ),
          ],
        ),
        // ----------------------------------
      ],
    );
  }
}
