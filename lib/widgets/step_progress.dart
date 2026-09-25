import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Three-segment progress bar used across the Create Account steps.
class StepProgress extends StatelessWidget {
  const StepProgress({super.key, required this.step, this.totalSteps = 3});

  final int step; // 1-indexed
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final active = i < step;
        return Expanded(
          child: Container(
            height: 5,
            margin: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 5),
            decoration: BoxDecoration(
              color: active ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
