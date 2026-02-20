import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/brand_model.dart';
import '../../domain/models/category_model.dart';

class CategoryRepository {
  final Dio _dio;

  CategoryRepository(this._dio);

  Future<List<Category>> getCategories({String? categoryType}) async {
    try {
      final params = <String, dynamic>{};
      if (categoryType != null) params['category_type'] = categoryType;

      final response = await _dio.get(
        ApiEndpoints.categories,
        queryParameters: params,
      );
      final data = response.data['data'] ?? response.data;
      final list = data is List ? data : (data['results'] as List? ?? data as List);
      return list
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Brand>> getBrands() async {
    try {
      final response = await _dio.get(ApiEndpoints.brands);
      final data = response.data['data'] ?? response.data;
      final list = data is List ? data : (data['results'] as List? ?? []);
      return list
          .map((e) => Brand.fromJson(e as Map<String, dynamic>))
          .toList();
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

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CategoryRepository(dio);
});
