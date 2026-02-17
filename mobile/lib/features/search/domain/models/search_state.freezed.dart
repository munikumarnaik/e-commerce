// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(List<String> items) suggestions,
    required TResult Function() loading,
    required TResult Function(SearchResult data) results,
    required TResult Function(String query) noResults,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(List<String> items)? suggestions,
    TResult? Function()? loading,
    TResult? Function(SearchResult data)? results,
    TResult? Function(String query)? noResults,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(List<String> items)? suggestions,
    TResult Function()? loading,
    TResult Function(SearchResult data)? results,
    TResult Function(String query)? noResults,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchIdle value) idle,
    required TResult Function(SearchSuggestions value) suggestions,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchResults value) results,
    required TResult Function(SearchNoResults value) noResults,
    required TResult Function(SearchError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchIdle value)? idle,
    TResult? Function(SearchSuggestions value)? suggestions,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchResults value)? results,
    TResult? Function(SearchNoResults value)? noResults,
    TResult? Function(SearchError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchIdle value)? idle,
    TResult Function(SearchSuggestions value)? suggestions,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchResults value)? results,
    TResult Function(SearchNoResults value)? noResults,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchStateCopyWith<$Res> {
  factory $SearchStateCopyWith(
          SearchState value, $Res Function(SearchState) then) =
      _$SearchStateCopyWithImpl<$Res, SearchState>;
}

/// @nodoc
class _$SearchStateCopyWithImpl<$Res, $Val extends SearchState>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SearchIdleImplCopyWith<$Res> {
  factory _$$SearchIdleImplCopyWith(
          _$SearchIdleImpl value, $Res Function(_$SearchIdleImpl) then) =
      __$$SearchIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SearchIdleImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchIdleImpl>
    implements _$$SearchIdleImplCopyWith<$Res> {
  __$$SearchIdleImplCopyWithImpl(
      _$SearchIdleImpl _value, $Res Function(_$SearchIdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SearchIdleImpl implements SearchIdle {
  const _$SearchIdleImpl();

  @override
  String toString() {
    return 'SearchState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SearchIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(List<String> items) suggestions,
    required TResult Function() loading,
    required TResult Function(SearchResult data) results,
    required TResult Function(String query) noResults,
    required TResult Function(String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(List<String> items)? suggestions,
    TResult? Function()? loading,
    TResult? Function(SearchResult data)? results,
    TResult? Function(String query)? noResults,
    TResult? Function(String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(List<String> items)? suggestions,
    TResult Function()? loading,
    TResult Function(SearchResult data)? results,
    TResult Function(String query)? noResults,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchIdle value) idle,
    required TResult Function(SearchSuggestions value) suggestions,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchResults value) results,
    required TResult Function(SearchNoResults value) noResults,
    required TResult Function(SearchError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchIdle value)? idle,
    TResult? Function(SearchSuggestions value)? suggestions,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchResults value)? results,
    TResult? Function(SearchNoResults value)? noResults,
    TResult? Function(SearchError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchIdle value)? idle,
    TResult Function(SearchSuggestions value)? suggestions,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchResults value)? results,
    TResult Function(SearchNoResults value)? noResults,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class SearchIdle implements SearchState {
  const factory SearchIdle() = _$SearchIdleImpl;
}

/// @nodoc
abstract class _$$SearchSuggestionsImplCopyWith<$Res> {
  factory _$$SearchSuggestionsImplCopyWith(_$SearchSuggestionsImpl value,
          $Res Function(_$SearchSuggestionsImpl) then) =
      __$$SearchSuggestionsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> items});
}

/// @nodoc
class __$$SearchSuggestionsImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchSuggestionsImpl>
    implements _$$SearchSuggestionsImplCopyWith<$Res> {
  __$$SearchSuggestionsImplCopyWithImpl(_$SearchSuggestionsImpl _value,
      $Res Function(_$SearchSuggestionsImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_$SearchSuggestionsImpl(
      null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$SearchSuggestionsImpl implements SearchSuggestions {
  const _$SearchSuggestionsImpl(final List<String> items) : _items = items;

  final List<String> _items;
  @override
  List<String> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'SearchState.suggestions(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchSuggestionsImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchSuggestionsImplCopyWith<_$SearchSuggestionsImpl> get copyWith =>
      __$$SearchSuggestionsImplCopyWithImpl<_$SearchSuggestionsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(List<String> items) suggestions,
    required TResult Function() loading,
    required TResult Function(SearchResult data) results,
    required TResult Function(String query) noResults,
    required TResult Function(String message) error,
  }) {
    return suggestions(items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(List<String> items)? suggestions,
    TResult? Function()? loading,
    TResult? Function(SearchResult data)? results,
    TResult? Function(String query)? noResults,
    TResult? Function(String message)? error,
  }) {
    return suggestions?.call(items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(List<String> items)? suggestions,
    TResult Function()? loading,
    TResult Function(SearchResult data)? results,
    TResult Function(String query)? noResults,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (suggestions != null) {
      return suggestions(items);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchIdle value) idle,
    required TResult Function(SearchSuggestions value) suggestions,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchResults value) results,
    required TResult Function(SearchNoResults value) noResults,
    required TResult Function(SearchError value) error,
  }) {
    return suggestions(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchIdle value)? idle,
    TResult? Function(SearchSuggestions value)? suggestions,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchResults value)? results,
    TResult? Function(SearchNoResults value)? noResults,
    TResult? Function(SearchError value)? error,
  }) {
    return suggestions?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchIdle value)? idle,
    TResult Function(SearchSuggestions value)? suggestions,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchResults value)? results,
    TResult Function(SearchNoResults value)? noResults,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) {
    if (suggestions != null) {
      return suggestions(this);
    }
    return orElse();
  }
}

abstract class SearchSuggestions implements SearchState {
  const factory SearchSuggestions(final List<String> items) =
      _$SearchSuggestionsImpl;

  List<String> get items;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchSuggestionsImplCopyWith<_$SearchSuggestionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchLoadingImplCopyWith<$Res> {
  factory _$$SearchLoadingImplCopyWith(
          _$SearchLoadingImpl value, $Res Function(_$SearchLoadingImpl) then) =
      __$$SearchLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SearchLoadingImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchLoadingImpl>
    implements _$$SearchLoadingImplCopyWith<$Res> {
  __$$SearchLoadingImplCopyWithImpl(
      _$SearchLoadingImpl _value, $Res Function(_$SearchLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SearchLoadingImpl implements SearchLoading {
  const _$SearchLoadingImpl();

  @override
  String toString() {
    return 'SearchState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SearchLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(List<String> items) suggestions,
    required TResult Function() loading,
    required TResult Function(SearchResult data) results,
    required TResult Function(String query) noResults,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(List<String> items)? suggestions,
    TResult? Function()? loading,
    TResult? Function(SearchResult data)? results,
    TResult? Function(String query)? noResults,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(List<String> items)? suggestions,
    TResult Function()? loading,
    TResult Function(SearchResult data)? results,
    TResult Function(String query)? noResults,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchIdle value) idle,
    required TResult Function(SearchSuggestions value) suggestions,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchResults value) results,
    required TResult Function(SearchNoResults value) noResults,
    required TResult Function(SearchError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchIdle value)? idle,
    TResult? Function(SearchSuggestions value)? suggestions,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchResults value)? results,
    TResult? Function(SearchNoResults value)? noResults,
    TResult? Function(SearchError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchIdle value)? idle,
    TResult Function(SearchSuggestions value)? suggestions,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchResults value)? results,
    TResult Function(SearchNoResults value)? noResults,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SearchLoading implements SearchState {
  const factory SearchLoading() = _$SearchLoadingImpl;
}

/// @nodoc
abstract class _$$SearchResultsImplCopyWith<$Res> {
  factory _$$SearchResultsImplCopyWith(
          _$SearchResultsImpl value, $Res Function(_$SearchResultsImpl) then) =
      __$$SearchResultsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SearchResult data});

  $SearchResultCopyWith<$Res> get data;
}

/// @nodoc
class __$$SearchResultsImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchResultsImpl>
    implements _$$SearchResultsImplCopyWith<$Res> {
  __$$SearchResultsImplCopyWithImpl(
      _$SearchResultsImpl _value, $Res Function(_$SearchResultsImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SearchResultsImpl(
      null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as SearchResult,
    ));
  }

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchResultCopyWith<$Res> get data {
    return $SearchResultCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value));
    });
  }
}

/// @nodoc

class _$SearchResultsImpl implements SearchResults {
  const _$SearchResultsImpl(this.data);

  @override
  final SearchResult data;

  @override
  String toString() {
    return 'SearchState.results(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultsImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultsImplCopyWith<_$SearchResultsImpl> get copyWith =>
      __$$SearchResultsImplCopyWithImpl<_$SearchResultsImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(List<String> items) suggestions,
    required TResult Function() loading,
    required TResult Function(SearchResult data) results,
    required TResult Function(String query) noResults,
    required TResult Function(String message) error,
  }) {
    return results(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(List<String> items)? suggestions,
    TResult? Function()? loading,
    TResult? Function(SearchResult data)? results,
    TResult? Function(String query)? noResults,
    TResult? Function(String message)? error,
  }) {
    return results?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(List<String> items)? suggestions,
    TResult Function()? loading,
    TResult Function(SearchResult data)? results,
    TResult Function(String query)? noResults,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (results != null) {
      return results(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchIdle value) idle,
    required TResult Function(SearchSuggestions value) suggestions,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchResults value) results,
    required TResult Function(SearchNoResults value) noResults,
    required TResult Function(SearchError value) error,
  }) {
    return results(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchIdle value)? idle,
    TResult? Function(SearchSuggestions value)? suggestions,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchResults value)? results,
    TResult? Function(SearchNoResults value)? noResults,
    TResult? Function(SearchError value)? error,
  }) {
    return results?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchIdle value)? idle,
    TResult Function(SearchSuggestions value)? suggestions,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchResults value)? results,
    TResult Function(SearchNoResults value)? noResults,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) {
    if (results != null) {
      return results(this);
    }
    return orElse();
  }
}

abstract class SearchResults implements SearchState {
  const factory SearchResults(final SearchResult data) = _$SearchResultsImpl;

  SearchResult get data;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultsImplCopyWith<_$SearchResultsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchNoResultsImplCopyWith<$Res> {
  factory _$$SearchNoResultsImplCopyWith(_$SearchNoResultsImpl value,
          $Res Function(_$SearchNoResultsImpl) then) =
      __$$SearchNoResultsImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String query});
}

/// @nodoc
class __$$SearchNoResultsImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchNoResultsImpl>
    implements _$$SearchNoResultsImplCopyWith<$Res> {
  __$$SearchNoResultsImplCopyWithImpl(
      _$SearchNoResultsImpl _value, $Res Function(_$SearchNoResultsImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
  }) {
    return _then(_$SearchNoResultsImpl(
      null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SearchNoResultsImpl implements SearchNoResults {
  const _$SearchNoResultsImpl(this.query);

  @override
  final String query;

  @override
  String toString() {
    return 'SearchState.noResults(query: $query)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchNoResultsImpl &&
            (identical(other.query, query) || other.query == query));
  }

  @override
  int get hashCode => Object.hash(runtimeType, query);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchNoResultsImplCopyWith<_$SearchNoResultsImpl> get copyWith =>
      __$$SearchNoResultsImplCopyWithImpl<_$SearchNoResultsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(List<String> items) suggestions,
    required TResult Function() loading,
    required TResult Function(SearchResult data) results,
    required TResult Function(String query) noResults,
    required TResult Function(String message) error,
  }) {
    return noResults(query);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(List<String> items)? suggestions,
    TResult? Function()? loading,
    TResult? Function(SearchResult data)? results,
    TResult? Function(String query)? noResults,
    TResult? Function(String message)? error,
  }) {
    return noResults?.call(query);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(List<String> items)? suggestions,
    TResult Function()? loading,
    TResult Function(SearchResult data)? results,
    TResult Function(String query)? noResults,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (noResults != null) {
      return noResults(query);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchIdle value) idle,
    required TResult Function(SearchSuggestions value) suggestions,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchResults value) results,
    required TResult Function(SearchNoResults value) noResults,
    required TResult Function(SearchError value) error,
  }) {
    return noResults(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchIdle value)? idle,
    TResult? Function(SearchSuggestions value)? suggestions,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchResults value)? results,
    TResult? Function(SearchNoResults value)? noResults,
    TResult? Function(SearchError value)? error,
  }) {
    return noResults?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchIdle value)? idle,
    TResult Function(SearchSuggestions value)? suggestions,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchResults value)? results,
    TResult Function(SearchNoResults value)? noResults,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) {
    if (noResults != null) {
      return noResults(this);
    }
    return orElse();
  }
}

abstract class SearchNoResults implements SearchState {
  const factory SearchNoResults(final String query) = _$SearchNoResultsImpl;

  String get query;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchNoResultsImplCopyWith<_$SearchNoResultsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SearchErrorImplCopyWith<$Res> {
  factory _$$SearchErrorImplCopyWith(
          _$SearchErrorImpl value, $Res Function(_$SearchErrorImpl) then) =
      __$$SearchErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SearchErrorImplCopyWithImpl<$Res>
    extends _$SearchStateCopyWithImpl<$Res, _$SearchErrorImpl>
    implements _$$SearchErrorImplCopyWith<$Res> {
  __$$SearchErrorImplCopyWithImpl(
      _$SearchErrorImpl _value, $Res Function(_$SearchErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SearchErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SearchErrorImpl implements SearchError {
  const _$SearchErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SearchState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchErrorImplCopyWith<_$SearchErrorImpl> get copyWith =>
      __$$SearchErrorImplCopyWithImpl<_$SearchErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(List<String> items) suggestions,
    required TResult Function() loading,
    required TResult Function(SearchResult data) results,
    required TResult Function(String query) noResults,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(List<String> items)? suggestions,
    TResult? Function()? loading,
    TResult? Function(SearchResult data)? results,
    TResult? Function(String query)? noResults,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(List<String> items)? suggestions,
    TResult Function()? loading,
    TResult Function(SearchResult data)? results,
    TResult Function(String query)? noResults,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SearchIdle value) idle,
    required TResult Function(SearchSuggestions value) suggestions,
    required TResult Function(SearchLoading value) loading,
    required TResult Function(SearchResults value) results,
    required TResult Function(SearchNoResults value) noResults,
    required TResult Function(SearchError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SearchIdle value)? idle,
    TResult? Function(SearchSuggestions value)? suggestions,
    TResult? Function(SearchLoading value)? loading,
    TResult? Function(SearchResults value)? results,
    TResult? Function(SearchNoResults value)? noResults,
    TResult? Function(SearchError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SearchIdle value)? idle,
    TResult Function(SearchSuggestions value)? suggestions,
    TResult Function(SearchLoading value)? loading,
    TResult Function(SearchResults value)? results,
    TResult Function(SearchNoResults value)? noResults,
    TResult Function(SearchError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SearchError implements SearchState {
  const factory SearchError(final String message) = _$SearchErrorImpl;

  String get message;

  /// Create a copy of SearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchErrorImplCopyWith<_$SearchErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
