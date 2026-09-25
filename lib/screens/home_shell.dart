import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'transactions_screen.dart';
import 'chats_screen.dart';
import 'profile_screen.dart';

/// Wraps the four primary tabs behind the bottom nav bar, matching the
/// Figma "Navbar - Both Modes" frame (Home / Orders / Chats / Profile).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    TransactionsScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];

  static const _items = [
    (icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    (icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: 'Orders'),
    (icon: Icons.chat_bubble_outline, activeIcon: Icons.chat_bubble, label: 'Chats'),
    (icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 4)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final selected = i == _index;
              final color = selected ? AppColors.primary : AppColors.placeholder;
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _index = i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(selected ? item.activeIcon : item.icon, size: 22, color: color),
                      const SizedBox(height: 4),
                      Text(item.label, style: TextStyle(fontSize: 10, color: color, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
