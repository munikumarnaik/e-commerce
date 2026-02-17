import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';

class SuggestionsList extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSuggestionTap;

  const SuggestionsList({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: Icon(
            Icons.search_rounded,
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          title: Text(suggestion),
          trailing: Icon(
            Icons.north_west_rounded,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          contentPadding: EdgeInsets.zero,
          onTap: () => onSuggestionTap(suggestion),
        );
      },
    );
  }
}
