import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/bank_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../screens/operations/deposit_screen.dart';
import '../../screens/operations/withdraw_screen.dart';
import '../../screens/operations/transfer_screen.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _headerFade;
  late Animation<double> _cardSlide;
  late Animation<double> _actionsSlide;
  late Animation<double> _recentFade;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _cardSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.15, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _actionsSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _recentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning ☀️';
    } else if (hour < 17) {
      return 'Good Afternoon 🌤️';
    } else {
      return 'Good Evening 🌙';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    final bankProvider = Provider.of<BankProvider>(context);
    final currencyFormat = NumberFormat.simpleCurrency(name: 'USD');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Profile Section & Security
                  FadeTransition(
                    opacity: _headerFade,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getGreeting(),
                                  style: TextStyle(
                                    color: AppColors.textLight.withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user?.name ?? 'User',
                                  style: AppTextStyles.heading,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                // Notification Bell
                                Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceVariant,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.glassBorder),
                                      ),
                                      child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
                                    ),
                                    Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: AppColors.error,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 14),
                                // Avatar
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<NavigationProvider>(context,
                                            listen: false)
                                        .setIndex(2);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppGradients.primary,
                                    ),
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        user?.name
                                                .substring(0, 1)
                                                .toUpperCase() ??
                                            'U',
                                        style: const TextStyle(
                                          color: AppColors.primaryBlue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Security Status Card
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) {
                            final loginTimeStr = auth.loginTime != null 
                              ? DateFormat('MMM d, h:mm a').format(auth.loginTime!)
                              : 'Just now';
                              
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.success.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.security_rounded, color: AppColors.success, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Account Secure',
                                    style: TextStyle(
                                      color: AppColors.success.withOpacity(0.9),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Logged in $loginTimeStr',
                                    style: TextStyle(
                                      color: AppColors.textLight.withOpacity(0.7),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // 2. Balance Card
                  Transform.translate(
                    offset: Offset(0, _cardSlide.value),
                    child: Opacity(
                      opacity: _headerFade.value,
                      child: Container(
                        width: double.infinity,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          gradient: AppGradients.bankCard,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.5),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Decorative rings
                            Positioned(
                              right: -50,
                              top: -50,
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                            ),
                            Positioned(
                              right: -20,
                              bottom: -80,
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.05),
                                ),
                              ),
                            ),
                            // Sparkline chart
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              height: 100, // height of the chart
                              child: CustomPaint(
                                painter: _SparklinePainter(
                                  bankProvider.balanceHistory.isEmpty 
                                    ? [0, 0, 0] // Dummy flat line if completely empty
                                    : bankProvider.balanceHistory,
                                  Colors.white,
                                ),
                              ),
                            ),
                            // Content
                            Padding(
                              padding: const EdgeInsets.all(28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total Balance',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.85),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          TweenAnimationBuilder<double>(
                                            tween: Tween<double>(
                                              begin: 0,
                                              end: bankProvider.balance,
                                            ),
                                            duration: const Duration(milliseconds: 1200),
                                            curve: Curves.easeOutCubic,
                                            builder: (context, value, child) {
                                              return Text(
                                                currencyFormat.format(value),
                                                style: AppTextStyles.balanceLarge,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(14),
                                        ),
                                        child: const Icon(
                                          Icons.account_balance_wallet_rounded,
                                          color: Colors.white,
                                          size: 26,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 38),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '**** **** **** ',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontSize: 15,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                          Text(
                                            user?.phone.isNotEmpty == true &&
                                                    user!.phone.length >= 4
                                                ? user.phone.substring(
                                                    user.phone.length - 4)
                                                : "1234",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'VISA',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                            letterSpacing: 2.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // 3. Quick Actions
                  Transform.translate(
                    offset: Offset(0, _actionsSlide.value),
                    child: Opacity(
                      opacity: _headerFade.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Actions',
                            style: AppTextStyles.subHeading,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildActionButton(
                                  context,
                                  icon: Icons.arrow_downward_rounded,
                                  label: 'Deposit',
                                  color: AppColors.success,
                                  onTap: () => Navigator.push(
                                    context,
                                    _slideRoute(const DepositScreen()),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  context,
                                  icon: Icons.swap_horiz_rounded,
                                  label: 'Transfer',
                                  color: AppColors.primaryBlue,
                                  isPrimary: true,
                                  onTap: () => Navigator.push(
                                    context,
                                    _slideRoute(const TransferScreen()),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  context,
                                  icon: Icons.arrow_upward_rounded,
                                  label: 'Withdraw',
                                  color: AppColors.warning,
                                  onTap: () => Navigator.push(
                                    context,
                                    _slideRoute(const WithdrawScreen()),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildActionButton(
                                  context,
                                  icon: Icons.receipt_long_rounded,
                                  label: 'Bills',
                                  color: AppColors.info,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Bill Pay arriving soon!'),
                                        backgroundColor: AppColors.surfaceVariant,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // 3.5 Income vs Expense & Quick Pay
                  Transform.translate(
                    offset: Offset(0, _actionsSlide.value * 0.6),
                    child: Opacity(
                      opacity: _headerFade.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.glassBorder),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: AppColors.success.withOpacity(0.15),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.arrow_downward_rounded, color: AppColors.success, size: 16),
                                          ),
                                          const SizedBox(width: 8),
                                          Text('Income', style: AppTextStyles.caption.copyWith(color: AppColors.textLight)),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        currencyFormat.format(bankProvider.totalIncome),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppColors.glassBorder),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: AppColors.error.withOpacity(0.15),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.arrow_upward_rounded, color: AppColors.error, size: 16),
                                          ),
                                          const SizedBox(width: 8),
                                          Text('Expenses', style: AppTextStyles.caption.copyWith(color: AppColors.textLight)),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        currencyFormat.format(bankProvider.totalExpense),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 36),
                          
                          // Quick Pay
                          const Text(
                            'Quick Send',
                            style: AppTextStyles.subHeading,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: bankProvider.favoriteContacts.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return GestureDetector(
                                    onTap: () {
                                       Navigator.push(context, _slideRoute(const TransferScreen()));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 16),
                                      width: 60,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.surface,
                                              border: Border.all(color: AppColors.primaryBlue, width: 1.5, strokeAlign: BorderSide.strokeAlignOutside),
                                            ),
                                            child: const Icon(Icons.add_rounded, color: AppColors.primaryBlue),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text('Add', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                
                                final contact = bankProvider.favoriteContacts[index - 1];
                                return GestureDetector(
                                    onTap: () {
                                      // Normally would navigate to transfer screen pre-filled
                                      Navigator.push(context, _slideRoute(const TransferScreen()));
                                    },
                                    child: Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    width: 64,
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                                          child: Text(
                                            contact.displayName.substring(0, 1).toUpperCase(),
                                            style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 18),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          contact.displayName,
                                          style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // 4. Special Offers
                  Transform.translate(
                    offset: Offset(0, _actionsSlide.value * 0.8),
                    child: Opacity(
                      opacity: _headerFade.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Special Offers',
                            style: AppTextStyles.subHeading,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 110,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                              gradient: AppGradients.button,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: AppShadows.glow(AppColors.primaryBlue.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Get 5% Cashback',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'On your next bill payment!',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.85),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.card_giftcard_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // 5. Recent Transactions
                  FadeTransition(
                    opacity: _recentFade,
                    child: _buildRecentTransactions(bankProvider, currencyFormat),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(
      BankProvider bankProvider, NumberFormat currencyFormat) {
    final recentTx =
        bankProvider.transactions.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Activity', style: AppTextStyles.subHeading),
            if (recentTx.isNotEmpty)
              TextButton(
                onPressed: () {
                  Provider.of<NavigationProvider>(context, listen: false)
                      .setIndex(1);
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primaryBlue.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (recentTx.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassBorder),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              children: [
                Icon(Icons.receipt_long_rounded,
                    size: 48, color: AppColors.textHint.withOpacity(0.4)),
                const SizedBox(height: 12),
                Text(
                  'No transactions yet',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppShadows.soft,
            ),
            child: Column(
              children: recentTx.asMap().entries.map((entry) {
                final index = entry.key;
                final tx = entry.value;
                return _buildTransactionTile(tx, currencyFormat,
                    isLast: index == recentTx.length - 1);
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionTile(
      TransactionModel tx, NumberFormat currencyFormat,
      {bool isLast = false}) {
    IconData icon;
    Color color;
    String title;
    String prefix;

    switch (tx.type) {
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
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
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('MMM d, h:mm a').format(tx.date),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Text(
                '$prefix${currencyFormat.format(tx.amount)}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 60,
            endIndent: 16,
            color: AppColors.surfaceVariant,
          ),
      ],
    );
  }

  Route _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return _ActionButton(
      icon: icon,
      label: label,
      color: color,
      onTap: onTap,
      isPrimary: isPrimary,
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: widget.isPrimary ? AppColors.primaryBlue : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: widget.isPrimary
                ? AppShadows.glow(AppColors.primaryBlue)
                : AppShadows.soft,
            border: widget.isPrimary
                ? null
                : Border.all(color: AppColors.glassBorder, width: 1),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.isPrimary
                      ? Colors.white.withOpacity(0.2)
                      : widget.color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: widget.isPrimary ? Colors.white : widget.color,
                  size: 26,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: widget.isPrimary ? Colors.white : AppColors.textDark,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _SparklinePainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    
    if (data.length == 1) {
       final paint = Paint()
        ..color = color
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;
       canvas.drawLine(Offset(0, size.height/2), Offset(size.width, size.height/2), paint);
       return;
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final minData = data.reduce((a, b) => a < b ? a : b);
    final maxData = data.reduce((a, b) => a > b ? a : b);
    final range = (maxData - minData) == 0 ? 1.0 : (maxData - minData);

    final path = Path();
    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (((data[i] - minData) / range) * (size.height * 0.8) + (size.height * 0.1));
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.3), color.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
      
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
      
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
