import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_buttons.dart';
import '../widgets/step_progress.dart';
import 'login_screen.dart';
import 'signup_step2_screen.dart';

class SignupStep1Screen extends StatelessWidget {
  const SignupStep1Screen({super.key});

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
                const StepProgress(step: 1),
                const SizedBox(height: 34),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(fontSize: 14, color: AppColors.bodyText),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const AppTextField(hint: 'First Name', icon: Icons.person_outline),
                const SizedBox(height: 14),
                const AppTextField(hint: 'Last Name', icon: Icons.person_outline),
                const SizedBox(height: 14),
                const AppTextField(
                  hint: '(+63) 9XX XXX XXXX',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 14),
                const AppTextField(hint: 'Email', icon: Icons.mail_outline),
                const SizedBox(height: 14),
                const AppTextField(
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  obscure: true,
                ),
                const SizedBox(height: 14),
                const AppTextField(
                  hint: 'Confirm Password',
                  icon: Icons.lock_outline,
                  obscure: true,
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Next',
                  trailingIcon: Icons.arrow_outward,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignupStep2Screen()),
                  ),
                ),
                const SizedBox(height: 20),
                const OrDivider(),
                const SizedBox(height: 20),
                const GoogleButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
