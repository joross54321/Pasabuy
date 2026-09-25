import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Matches the "Navbar - Both Modes" frame: Home, Orders, Chats, History, Profile,
/// with a raised center action button used on the shopper/requester variants for
/// "New Trip" / "My Order".
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.centerLabel = 'New Trip',
    this.centerIcon = Icons.storefront_outlined,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final String centerLabel;
  final IconData centerIcon;

  static const _items = [
    (icon: Icons.home_outlined, label: 'Home'),
    (icon: Icons.shopping_bag_outlined, label: 'Orders'),
    null, // center FAB slot
    (icon: Icons.history, label: 'History'),
    (icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 78,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 54,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_items.length, (i) {
                  final item = _items[i];
                  if (item == null) {
                    return const SizedBox(width: 48);
                  }
                  final selected = i == currentIndex;
                  final color = selected ? AppColors.primary : AppColors.placeholder;
                  return InkWell(
                    onTap: () => onTap(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, size: 20, color: color),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(fontSize: 9, color: color),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () => onTap(2),
                child: Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x337C3AED),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(centerIcon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      centerLabel,
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
