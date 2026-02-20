import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/create_product_request.dart';

final adminProductRepositoryProvider = Provider<AdminProductRepository>((ref) {
  return AdminProductRepository(ref.watch(dioProvider));
});

class AdminProductRepository {
  final Dio _dio;

  AdminProductRepository(this._dio);

  /// Extracts the inner `data` field from the standard API wrapper.
  /// Response format: {"success": true, "data": {...}}
  Map<String, dynamic> _extractData(dynamic responseData) {
    final body = responseData as Map<String, dynamic>;
    return (body['data'] as Map<String, dynamic>?) ?? body;
  }

  Future<Map<String, dynamic>> createProduct(CreateProductRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.createProduct,
      data: request.toJson(),
    );
    return _extractData(response.data);
  }

  Future<Map<String, dynamic>> uploadImage(String slug, XFile image) async {
    final bytes = await image.readAsBytes();
    final formData = FormData.fromMap({
      'image': MultipartFile.fromBytes(bytes, filename: image.name),
    });

    final response = await _dio.post(
      ApiEndpoints.uploadProductImage(slug),
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    return _extractData(response.data);
  }

  Future<Map<String, dynamic>> updateProduct(
    String slug,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.patch(
      ApiEndpoints.updateProduct(slug),
      data: data,
    );
    return _extractData(response.data);
  }

  Future<Map<String, dynamic>> createCategory({
    required String name,
    required String categoryType,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.categoryCreate,
      data: {
        'name': name,
        'category_type': categoryType,
      },
    );
    return _extractData(response.data);
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await _dio.get(ApiEndpoints.adminDashboardStats);
    return _extractData(response.data);
  }
}
