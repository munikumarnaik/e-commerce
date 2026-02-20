import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/validators.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final strength = Validators.passwordStrength(password);
    final (label, color) = switch (strength) {
      0 => ('Weak', Colors.red),
      1 => ('Medium', Colors.orange),
      _ => ('Strong', Colors.green),
    };

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(
                    right: index < 2 ? AppDimensions.xs : 0,
                  ),
                  decoration: BoxDecoration(
                    color: index <= strength
                        ? color
                        : Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
