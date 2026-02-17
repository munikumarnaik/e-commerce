import 'package:freezed_annotation/freezed_annotation.dart';
import 'search_result_model.dart';

part 'search_state.freezed.dart';

@freezed
sealed class SearchState with _$SearchState {
  const factory SearchState.idle() = SearchIdle;
  const factory SearchState.suggestions(List<String> items) = SearchSuggestions;
  const factory SearchState.loading() = SearchLoading;
  const factory SearchState.results(SearchResult data) = SearchResults;
  const factory SearchState.noResults(String query) = SearchNoResults;
  const factory SearchState.error(String message) = SearchError;
}
