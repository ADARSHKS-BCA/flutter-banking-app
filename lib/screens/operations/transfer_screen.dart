import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bank_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../utils/constants.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleTransfer() async {
    final amount = double.tryParse(_amountController.text);
    final recipient = _recipientController.text.trim();

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (recipient.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter recipient username')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Transfer'),
        content: Text('Send \$$amount to $recipient?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      final success = await Provider.of<BankProvider>(context, listen: false)
          .transfer(recipient, amount);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transfer Successful!'),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pop(context); // Go back to Home
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transfer Failed. Check balance or username.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transfer Money'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             // Balance Context
             Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_balance_wallet_outlined, size: 20, color: AppColors.primaryBlue.withOpacity(0.8)),
                    const SizedBox(width: 8),
                    Text(
                      'Balance: \$${Provider.of<BankProvider>(context).balance.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: AppColors.primaryBlue.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
             ),
            const SizedBox(height: 32),
            
            const Text(
              'Recipient Details',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w600, 
                color: AppColors.textLight
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Recipient Username',
              controller: _recipientController,
              prefixIcon: Icons.person_search_rounded,
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Transfer Amount',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w600, 
                color: AppColors.textLight
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Amount',
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: Icons.attach_money_rounded,
            ),
            const SizedBox(height: 40),
            
            PrimaryButton(
              text: 'Transfer Now',
              onPressed: _handleTransfer,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
