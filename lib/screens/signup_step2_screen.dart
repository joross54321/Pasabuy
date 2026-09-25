import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_buttons.dart';
import '../widgets/step_progress.dart';
import 'signup_step3_screen.dart';

class SignupStep2Screen extends StatelessWidget {
  const SignupStep2Screen({super.key});

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
                const StepProgress(step: 2),
                const SizedBox(height: 34),
                const Text(
                  'Set your Location',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'This helps us match you with nearby shoppers.',
                  style: TextStyle(fontSize: 14, color: AppColors.bodyText),
                ),
                const SizedBox(height: 20),
                // Map placeholder
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 240,
                    width: double.infinity,
                    color: AppColors.surface,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 64,
                          color: AppColors.accent.withOpacity(0.4),
                        ),
                        const Icon(
                          Icons.location_on,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Your Base Address',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Drag the map or type to change your address',
                  style: TextStyle(fontSize: 12, color: AppColors.placeholder),
                ),
                const SizedBox(height: 12),
                const AppTextField(
                  hint: 'Plaza Rizal St, Jaro, Iloilo City, 5000 Iloilo',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: 'Next',
                  trailingIcon: Icons.arrow_outward,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignupStep3Screen()),
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
