import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bank_provider.dart';
import '../../models/transaction_model.dart'; // Added Import
import '../../utils/constants.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bankProvider = Provider.of<BankProvider>(context);
    final currencyFormat = NumberFormat.simpleCurrency(name: 'USD');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: bankProvider.transactions.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No transactions yet', style: AppTextStyles.body),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bankProvider.transactions.length,
              itemBuilder: (context, index) {
                final transaction = bankProvider.transactions[index];
                
                IconData icon;
                Color color;
                String title;
                String prefix;

                switch (transaction.type) {
                  case TransactionType.deposit:
                    icon = Icons.arrow_downward;
                    color = AppColors.success;
                    title = 'Deposit';
                    prefix = '+';
                    break;
                  case TransactionType.transfer:
                     icon = Icons.swap_horiz;
                     color = AppColors.primaryBlue; 
                     title = 'Transfer';
                     prefix = '-';
                     break;
                  case TransactionType.withdraw:
                  default:
                    icon = Icons.arrow_upward;
                    color = AppColors.error;
                    title = 'Withdrawal';
                    prefix = '-';
                    break;
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.1),
                      child: Icon(icon, color: color),
                    ),
                    title: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat('MMM d, yyyy h:mm a').format(transaction.date),
                    ),
                    trailing: Text(
                      '$prefix${currencyFormat.format(transaction.amount)}',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
