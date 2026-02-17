import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';

enum ButtonVariant { primary, outlined, text }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonVariant variant;
  final IconData? icon;
  final bool fullWidth;
  final double? height;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.fullWidth = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveOnPressed = (isLoading || isDisabled) ? null : onPressed;
    final buttonHeight = height ?? AppDimensions.buttonHeight;

    Widget child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: variant == ButtonVariant.primary
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
          )
        : Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppDimensions.sm),
              ],
              Text(label),
            ],
          );

    return switch (variant) {
      ButtonVariant.primary => SizedBox(
          width: fullWidth ? double.infinity : null,
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: effectiveOnPressed,
            child: child,
          ),
        ),
      ButtonVariant.outlined => SizedBox(
          width: fullWidth ? double.infinity : null,
          height: buttonHeight,
          child: OutlinedButton(
            onPressed: effectiveOnPressed,
            child: child,
          ),
        ),
      ButtonVariant.text => TextButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
    };
  }
}
