import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_buttons.dart';
import '../widgets/step_progress.dart';
import 'home_shell.dart';

enum PasabuyRole { requester, shopper }

class SignupStep3Screen extends StatefulWidget {
  const SignupStep3Screen({super.key});

  @override
  State<SignupStep3Screen> createState() => _SignupStep3ScreenState();
}

class _SignupStep3ScreenState extends State<SignupStep3Screen> {
  PasabuyRole? _selected = PasabuyRole.requester;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLogin,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const StepProgress(step: 3),
                const SizedBox(height: 34),
                const Text(
                  'How will you use Pasabuy?',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Pick your default role. You can switch anytime from the app.',
                  style: TextStyle(fontSize: 14, color: AppColors.bodyText),
                ),
                const SizedBox(height: 24),
                _RoleCard(
                  icon: Icons.shopping_basket_outlined,
                  title: 'Requester',
                  description:
                      'I request items for nearby shoppers already heading to the store. Fast, easy, no need to go out',
                  selected: _selected == PasabuyRole.requester,
                  onTap: () => setState(() => _selected = PasabuyRole.requester),
                ),
                const SizedBox(height: 16),
                _RoleCard(
                  icon: Icons.storefront_outlined,
                  title: 'Shopper',
                  description:
                      'I go to store and hitch items for others nearby. I earn by delivering their items on my way back.',
                  selected: _selected == PasabuyRole.shopper,
                  onTap: () => setState(() => _selected = PasabuyRole.shopper),
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: 'Get Started',
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeShell()),
                    (route) => false,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0x14111827),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: const [
            BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: AppColors.bodyText, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : AppColors.placeholder,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }
}
