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
    // 1. Determine what text to show
    final displayText = selectedBank != null
        ? '${selectedBank!.shortName} - ${selectedBank!.name}'
        : 'Chọn Ngân Hàng';

    // 2. We mimic the Look of a Dropdown using InputDecorator
    return InkWell(
      onTap: () => _showSearchDialog(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Chọn Ngân Hàng',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.account_balance),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          displayText,
          style: selectedBank == null
              ? Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)
              : Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _BankSearchDialog(banks: banks, onSelect: onChanged);
      },
    );
  }
}

// --- Internal Widget: The Search Popup ---
class _BankSearchDialog extends StatefulWidget {
  final List<Bank> banks;
  final ValueChanged<Bank?> onSelect;

  const _BankSearchDialog({required this.banks, required this.onSelect});

  @override
  State<_BankSearchDialog> createState() => _BankSearchDialogState();
}

class _BankSearchDialogState extends State<_BankSearchDialog> {
  late List<Bank> _filteredBanks;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredBanks = widget.banks;
  }

  void _filterBanks(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBanks = widget.banks;
      } else {
        final lowerQuery = query.toLowerCase();
        _filteredBanks = widget.banks.where((bank) {
          final nameInfo = '${bank.shortName} ${bank.name}'.toLowerCase();
          return nameInfo.contains(lowerQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dialog wrapper
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // Constrain width for Web so it doesn't stretch full screen
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          children: [
            // Header with Title and Close button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chọn Ngân Hàng',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm (VD: MB, VCB...)',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: _filterBanks,
              ),
            ),

            // Bank List
            Expanded(
              child: _filteredBanks.isEmpty
                  ? const Center(child: Text('Không tìm thấy kết quả'))
                  : ListView.separated(
                      itemCount: _filteredBanks.length,
                      separatorBuilder: (ctx, index) =>
                          const Divider(height: 1, indent: 16, endIndent: 16),
                      itemBuilder: (context, index) {
                        final bank = _filteredBanks[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 4,
                          ),
                          leading: const Icon(
                            Icons.account_balance_wallet_outlined,
                          ),
                          title: Text(bank.shortName),
                          subtitle: Text(bank.name),
                          hoverColor: Colors.blue.withValues(
                            alpha: 0.1,
                          ), // Nice hover effect for Web
                          onTap: () {
                            widget.onSelect(bank);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
