import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../product/domain/models/brand_model.dart';
import '../../../product/domain/models/category_model.dart';
import '../../../product/domain/models/product_model.dart';
import '../../domain/models/search_result_model.dart';

class SearchRepository {
  final Dio _dio;

  SearchRepository(this._dio);

  Future<SearchResult> search(String query, {String? type}) async {
    try {
      final params = <String, dynamic>{'q': query};
      if (type != null) params['type'] = type;

      final response = await _dio.get(
        ApiEndpoints.search,
        queryParameters: params,
      );
      final data = response.data['data'];

      final products = (data['products']?['results'] as List? ?? [])
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
      final categories = (data['categories']?['results'] as List? ?? [])
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
      final brands = (data['brands']?['results'] as List? ?? [])
          .map((e) => Brand.fromJson(e as Map<String, dynamic>))
          .toList();

      return SearchResult(
        query: data['query'] ?? query,
        products: products,
        categories: categories,
        brands: brands,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<String>> getSuggestions(String query) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.searchSuggestions,
        queryParameters: {'q': query},
      );
      final data = response.data['data'];
      return List<String>.from(data['suggestions'] ?? []);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException e) {
    if (e.error is AppException) {
      return e.error as AppException;
    }
    return const UnknownException();
  }
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SearchRepository(dio);
});
