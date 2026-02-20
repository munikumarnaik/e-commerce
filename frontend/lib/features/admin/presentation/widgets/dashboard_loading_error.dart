import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';

// ── Loading Skeleton ──

class DashboardLoadingGrid extends StatelessWidget {
  const DashboardLoadingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppDimensions.md),
        children: [
          _shimmer(context, 120),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _shimmer(context, 140)),
            const SizedBox(width: 12),
            Expanded(child: _shimmer(context, 140)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _shimmer(context, 130)),
            const SizedBox(width: 12),
            Expanded(child: _shimmer(context, 130)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _shimmer(context, 130)),
            const SizedBox(width: 12),
            Expanded(child: _shimmer(context, 130)),
          ]),
          const SizedBox(height: 16),
          _shimmer(context, 240),
          const SizedBox(height: 12),
          _shimmer(context, 80),
        ],
      ),
    );
  }

  Widget _shimmer(BuildContext context, double height) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

// ── Error State ──

class DashboardErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const DashboardErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: theme.colorScheme.error.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            Text(
              'Failed to load stats',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.lg),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
