import 'package:flutter/material.dart';
import 'package:my_qr_cafe/features/custom_qr/models/bank_model.dart';

class BankSelector extends StatelessWidget {
  final List<Bank> banks;
  final Bank? selectedBank;
  final ValueChanged<Bank?> onChanged;

  const BankSelector({
    super.key,
    required this.banks,
    required this.selectedBank,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Bank>(
      decoration: const InputDecoration(
        labelText: 'Chọn Ngân Hàng',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.account_balance),
      ),
      initialValue: selectedBank,
      isExpanded: true,
      items: banks.map((bank) {
        return DropdownMenuItem(
          value: bank,
          child: Text(
            '${bank.shortName} - ${bank.name}',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
