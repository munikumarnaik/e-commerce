import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/models/search_state.dart';
import '../providers/search_provider.dart';
import '../widgets/recent_searches.dart';
import '../widgets/search_results_grid.dart';
import '../widgets/search_suggestions.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: AppStrings.searchProducts,
            border: InputBorder.none,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          style: theme.textTheme.bodyLarge,
          textInputAction: TextInputAction.search,
          onChanged: (query) =>
              ref.read(searchProvider.notifier).onQueryChanged(query),
          onSubmitted: (query) => _performSearch(query),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                _controller.clear();
                ref.read(searchProvider.notifier).clear();
              },
            ),
        ],
      ),
      body: _buildBody(searchState, theme),
    );
  }

  Widget _buildBody(SearchState state, ThemeData theme) {
    return state.when(
      idle: () => RecentSearches(
        onSearchTap: (query) {
          _controller.text = query;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: query.length),
          );
          _performSearch(query);
        },
      ),
      suggestions: (suggestions) => suggestions.isEmpty
          ? const SizedBox.shrink()
          : SuggestionsList(
              suggestions: suggestions,
              onSuggestionTap: (suggestion) {
                _controller.text = suggestion;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: suggestion.length),
                );
                _performSearch(suggestion);
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      results: (result) => SearchResultsGrid(products: result.products),
      noResults: (query) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 56,
                color: theme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.4),
              ),
              const SizedBox(height: AppDimensions.md),
              Text(
                AppStrings.noResults,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.xs),
              Text(
                AppStrings.noResultsSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      error: (message) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: AppDimensions.md),
              Text(message),
              const SizedBox(height: AppDimensions.lg),
              FilledButton.tonal(
                onPressed: () => _performSearch(_controller.text),
                child: const Text(AppStrings.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    RecentSearches.addSearch(query.trim());
    ref.read(searchProvider.notifier).search(query);
  }
}
