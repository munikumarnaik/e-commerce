import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/search_repository.dart';
import '../../domain/models/search_state.dart';

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchRepository _repository;
  Timer? _debounceTimer;

  SearchNotifier(this._repository) : super(const SearchState.idle());

  void onQueryChanged(String query) {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      state = const SearchState.idle();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _fetchSuggestions(query.trim());
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    try {
      final suggestions = await _repository.getSuggestions(query);
      if (suggestions.isNotEmpty) {
        state = SearchState.suggestions(suggestions);
      } else {
        state = const SearchState.suggestions([]);
      }
    } catch (_) {
      // Silently fail for suggestions
    }
  }

  Future<void> search(String query) async {
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) return;

    state = const SearchState.loading();

    try {
      final result = await _repository.search(query.trim());
      if (result.products.isEmpty &&
          result.categories.isEmpty &&
          result.brands.isEmpty) {
        state = SearchState.noResults(query.trim());
      } else {
        state = SearchState.results(result);
      }
    } catch (e) {
      state = SearchState.error(e.toString());
    }
  }

  void clear() {
    _debounceTimer?.cancel();
    state = const SearchState.idle();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final searchProvider =
    StateNotifierProvider.autoDispose<SearchNotifier, SearchState>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchNotifier(repository);
});
