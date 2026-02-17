import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashLoadingBar extends StatelessWidget {
  const SplashLoadingBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 160,
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
          valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
        ),
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms);
  }
}
