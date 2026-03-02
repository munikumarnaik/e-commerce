import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/search_provider.dart';

class TrendingSearches extends ConsumerWidget {
  final ValueChanged<String> onSearchTap;

  const TrendingSearches({super.key, required this.onSearchTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAsync = ref.watch(trendingSearchesProvider);
    final theme = Theme.of(context);

    return trendingAsync.when(
      data: (searches) {
        if (searches.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Text(
                    AppStrings.trendingSearches,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.sm),
              Wrap(
                spacing: AppDimensions.sm,
                runSpacing: AppDimensions.sm,
                children: searches.map((query) {
                  return GestureDetector(
                    onTap: () => onSearchTap(query),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.md,
                        vertical: AppDimensions.sm,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer
                            .withValues(alpha: 0.3),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusFull),
                        border: Border.all(
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        query,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
