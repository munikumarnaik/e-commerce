import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/models/product_filter.dart';
import '../../domain/models/product_model.dart';

enum ProductListStatus { initial, loading, loaded, error }

class ProductListState {
  final ProductListStatus status;
  final List<Product> products;
  final int currentPage;
  final bool hasMore;
  final String? errorMessage;
  final ProductFilter filter;
  final bool isLoadingMore;

  ProductListState({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.errorMessage,
    ProductFilter? filter,
    this.isLoadingMore = false,
  }) : filter = filter ?? ProductFilter();

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? products,
    int? currentPage,
    bool? hasMore,
    String? errorMessage,
    ProductFilter? filter,
    bool? isLoadingMore,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ProductListNotifier extends StateNotifier<ProductListState> {
  final ProductRepository _repository;

  ProductListNotifier(this._repository) : super(ProductListState());

  Future<void> loadProducts({ProductFilter? filter}) async {
    final activeFilter = filter ?? state.filter;
    state = ProductListState(
      status: ProductListStatus.loading,
      filter: activeFilter,
    );

    try {
      final response = await _repository.getProducts(
        queryParams: activeFilter.toQueryParameters(),
        page: 1,
      );
      state = state.copyWith(
        status: ProductListStatus.loaded,
        products: response.results,
        currentPage: response.page,
        hasMore: response.hasMore,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        status: ProductListStatus.error,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        status: ProductListStatus.error,
        errorMessage: 'Failed to load products',
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final response = await _repository.getProducts(
        queryParams: state.filter.toQueryParameters(),
        page: state.currentPage + 1,
      );
      final newProducts = response.results;
      state = state.copyWith(
        products: [...state.products, ...newProducts],
        currentPage: response.page,
        // If backend returned empty list or no next page, stop
        hasMore: newProducts.isNotEmpty && response.hasMore,
        isLoadingMore: false,
      );
    } catch (_) {
      // On any error (404 invalid page, network, etc.) stop loading more
      state = state.copyWith(isLoadingMore: false, hasMore: false);
    }
  }

  Future<void> refresh() async {
    await loadProducts(filter: state.filter);
  }

  void updateFilter(ProductFilter filter) {
    loadProducts(filter: filter);
  }

  void setCategoryType(String? categoryType) {
    final newFilter = state.filter.copyWith();
    newFilter.categoryType = categoryType;
    loadProducts(filter: newFilter);
  }
}

final productListProvider =
    StateNotifierProvider<ProductListNotifier, ProductListState>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return ProductListNotifier(repository);
});

/// Provider that auto-reloads when active category changes
final homeProductListProvider =
    StateNotifierProvider<ProductListNotifier, ProductListState>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  final category = ref.watch(activeCategoryProvider);
  final notifier = ProductListNotifier(repository);

  final categoryType = switch (category) {
    AppCategory.food => 'FOOD',
    AppCategory.clothing => 'CLOTHING',
  };

  notifier.loadProducts(
    filter: ProductFilter(categoryType: categoryType),
  );

  return notifier;
});
