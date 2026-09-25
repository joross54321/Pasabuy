import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class _Txn {
  const _Txn({
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.status,
    required this.time,
    required this.amount,
    required this.amountLabel,
    required this.positive,
  });

  final String title;
  final String subtitle1;
  final String subtitle2;
  final String status; // Completed / Cancelled
  final String time;
  final String amount;
  final String amountLabel; // Earned / Paid
  final bool positive;
}

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  int _tab = 0;
  final _tabs = const ['All', 'Shopping Trips', 'My Orders'];

  final _groups = const {
    'Today': [
      _Txn(
        title: 'Shopping Trip Completed',
        subtitle1: 'You shopped for Maria Santos',
        subtitle2: 'SM City Iloilo • 6 items',
        status: 'Cancelled',
        time: '10:24 AM',
        amount: '+ ₱ 120.00',
        amountLabel: 'Earned',
        positive: true,
      ),
    ],
    'Yesterday': [
      _Txn(
        title: 'Order Received',
        subtitle1: 'Shopper: Miguel Reyes',
        subtitle2: 'Robinsons Iloilo • 6 items',
        status: 'Completed',
        time: '8:35 AM',
        amount: '- ₱ 380.00',
        amountLabel: 'Paid',
        positive: false,
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transactions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 16),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final selected = i == _tab;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _tab = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _tabs[i],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: selected ? Colors.white : AppColors.placeholder,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, size: 18, color: AppColors.placeholder),
                  SizedBox(width: 10),
                  Text('Search transactions', style: TextStyle(fontSize: 14, color: AppColors.placeholder)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  for (final entry in _groups.entries) ...[
                    const SizedBox(height: 12),
                    Text(
                      entry.key,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 10),
                    for (final t in entry.value) _TxnCard(t: t),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TxnCard extends StatelessWidget {
  const _TxnCard({required this.t});
  final _Txn t;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark)),
                const SizedBox(height: 6),
                Text(t.subtitle1, style: const TextStyle(fontSize: 12, color: AppColors.bodyText)),
                const SizedBox(height: 2),
                Text(t.subtitle2, style: const TextStyle(fontSize: 12, color: AppColors.placeholder)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: t.status == 'Completed' ? AppColors.success.withOpacity(0.1) : AppColors.danger.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    t.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: t.status == 'Completed' ? AppColors.success : AppColors.danger,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(t.time, style: const TextStyle(fontSize: 12, color: AppColors.placeholder)),
              const SizedBox(height: 22),
              Text(
                t.amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: t.positive ? AppColors.success : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(t.amountLabel, style: const TextStyle(fontSize: 11, color: AppColors.placeholder)),
            ],
          ),
        ],
      ),
    );
  }
}
