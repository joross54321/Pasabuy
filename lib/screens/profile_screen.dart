import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isRequesterMode = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Row(
            children: [
              const Text(
                'Profile',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const Spacer(),
              const Icon(Icons.settings_outlined, color: AppColors.textDark),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.surface,
                    child: const Icon(Icons.person, size: 40, color: AppColors.primary),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_outlined, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Juan Dela Cruz',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.location_on_outlined, size: 14, color: AppColors.placeholder),
                        SizedBox(width: 6),
                        Text('Iloilo City, Philippines', style: TextStyle(fontSize: 12, color: AppColors.bodyText)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.placeholder),
                        SizedBox(width: 6),
                        Text('Member since 2026', style: TextStyle(fontSize: 12, color: AppColors.bodyText)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Wallet Balance', style: TextStyle(fontSize: 14, color: AppColors.bodyText)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20)),
                      child: const Row(
                        children: [
                          Text('GCash', style: TextStyle(fontSize: 11, color: AppColors.primary)),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right, size: 12, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '₱ 500.00',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
                        label: const Text('Deposit', style: TextStyle(color: AppColors.primary)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_upward, size: 16, color: AppColors.primary),
                        label: const Text('Withdraw', style: TextStyle(color: AppColors.primary)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Current Activity', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isRequesterMode = true),
                    child: _ModeTile(
                      icon: Icons.shopping_basket_outlined,
                      label: 'Need Something',
                      selected: _isRequesterMode,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isRequesterMode = false),
                    child: _ModeTile(
                      icon: Icons.storefront_outlined,
                      label: 'Going Shopping',
                      selected: !_isRequesterMode,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Account', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: const [
                _MenuRow(icon: Icons.person_outline, label: 'Manage Profile'),
                _Divider(),
                _MenuRow(icon: Icons.location_on_outlined, label: 'Base Address'),
                _Divider(),
                _MenuRow(icon: Icons.mail_outline, label: 'Email Address'),
                _Divider(),
                _MenuRow(icon: Icons.phone_outlined, label: 'Phone Number'),
                _Divider(),
                _MenuRow(icon: Icons.logout, label: 'Log Out', danger: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({required this.icon, required this.label, required this.selected});

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: selected ? Colors.white : AppColors.placeholder),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selected ? Colors.white : AppColors.placeholder,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.label, this.danger = false});

  final IconData icon;
  final String label;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : AppColors.textDark;
    return ListTile(
      leading: Icon(icon, size: 20, color: danger ? AppColors.danger : AppColors.placeholder),
      title: Text(label, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500)),
      trailing: danger ? null : const Icon(Icons.chevron_right, size: 18, color: AppColors.placeholder),
      onTap: () {},
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => const Divider(height: 1, indent: 16, endIndent: 16, color: Color(0x11000000));
}
