import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> labels;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isActive = index <= currentStep;
          final isCurrent = index == currentStep;

          return Expanded(
            child: Row(
              children: [
                // Step circle
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                    border: isCurrent
                        ? Border.all(
                            color: theme.colorScheme.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Center(
                    child: index < currentStep
                        ? Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: theme.colorScheme.onPrimary,
                          )
                        : Text(
                            '${index + 1}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isActive
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                // Connector line
                if (index < labels.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.xs),
                      color: index < currentStep
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
