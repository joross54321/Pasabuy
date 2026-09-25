import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The rounded "pill" text input used across Login / Sign up / Address screens.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hint,
    this.icon,
    this.obscure = false,
    this.keyboardType,
    this.controller,
  });

  final String hint;
  final IconData? icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(85),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 16, color: AppColors.placeholder),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: _obscured,
              keyboardType: widget.keyboardType,
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.placeholder,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (widget.obscure)
            GestureDetector(
              onTap: () => setState(() => _obscured = !_obscured),
              child: Icon(
                _obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 16,
                color: AppColors.placeholder,
              ),
            ),
        ],
      ),
    );
  }
}
