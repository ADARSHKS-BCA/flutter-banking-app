import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/bank_provider.dart';
import '../../models/transaction_model.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bankProvider = Provider.of<BankProvider>(context);
    final currencyFormat = NumberFormat.simpleCurrency(name: 'USD');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Gradient header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 24,
              left: 24,
              right: 24,
            ),
            decoration: const BoxDecoration(
              gradient: AppGradients.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Transaction History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_balance_wallet_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        '${bankProvider.transactions.length} transactions',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Transaction list
          Expanded(
            child: bankProvider.transactions.isEmpty
                ? _buildEmptyState()
                : _buildTransactionList(bankProvider, currencyFormat),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 56,
                color: AppColors.primaryBlue.withOpacity(0.3),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No transactions yet',
            style: AppTextStyles.subHeading.copyWith(
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your transactions will appear here',
            style: AppTextStyles.body.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(
      BankProvider bankProvider, NumberFormat currencyFormat) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      itemCount: bankProvider.transactions.length,
      itemBuilder: (context, index) {
        final transaction = bankProvider.transactions[index];

        // Stagger animation per item
        final startInterval = (index * 0.08).clamp(0.0, 0.6);
        final endInterval = (startInterval + 0.4).clamp(0.0, 1.0);

        return AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            final progress = CurvedAnimation(
              parent: _animController,
              curve: Interval(startInterval, endInterval,
                  curve: Curves.easeOutCubic),
            ).value;

            return Transform.translate(
              offset: Offset(0, 30 * (1 - progress)),
              child: Opacity(
                opacity: progress,
                child: child,
              ),
            );
          },
          child: _buildTransactionCard(transaction, currencyFormat),
        );
      },
    );
  }

  Widget _buildTransactionCard(
      TransactionModel transaction, NumberFormat currencyFormat) {
    IconData icon;
    Color color;
    String title;
    String prefix;

    switch (transaction.type) {
      case TransactionType.deposit:
        icon = Icons.arrow_downward_rounded;
        color = AppColors.success;
        title = 'Deposit';
        prefix = '+';
        break;
      case TransactionType.transfer:
        icon = Icons.swap_horiz_rounded;
        color = AppColors.primaryBlue;
        title = 'Transfer';
        prefix = '-';
        break;
      case TransactionType.withdraw:
        icon = Icons.arrow_upward_rounded;
        color = AppColors.error;
        title = 'Withdrawal';
        prefix = '-';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          // Color accent stripe
          Container(
            width: 4,
            height: 72,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, yyyy  h:mm a').format(transaction.date),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Text(
              '$prefix${currencyFormat.format(transaction.amount)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
