import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

const _boxName = 'recent_searches';
const _maxRecent = 10;

class RecentSearches extends StatelessWidget {
  final ValueChanged<String> onSearchTap;

  const RecentSearches({super.key, required this.onSearchTap});

  static Future<void> addSearch(String query) async {
    final box = await Hive.openBox<String>(_boxName);
    final existing = box.values.toList();
    existing.remove(query);
    existing.insert(0, query);
    if (existing.length > _maxRecent) {
      existing.removeRange(_maxRecent, existing.length);
    }
    await box.clear();
    await box.addAll(existing);
  }

  static Future<void> clearAll() async {
    final box = await Hive.openBox<String>(_boxName);
    await box.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<Box<String>>(
      future: Hive.openBox<String>(_boxName),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        return ValueListenableBuilder<Box<String>>(
          valueListenable: snapshot.data!.listenable(),
          builder: (context, box, _) {
            final searches = box.values.toList();
            if (searches.isEmpty) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.recentSearches,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => clearAll(),
                        child: Text(
                          AppStrings.clearAll,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
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
                            color:
                                theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull),
                          ),
                          child: Text(
                            query,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
