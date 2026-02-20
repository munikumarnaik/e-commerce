import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/address_model.dart';

class AddressRepository {
  final Dio _dio;

  AddressRepository(this._dio);

  Future<List<Address>> getAddresses() async {
    try {
      final response = await _dio.get(ApiEndpoints.addresses);
      final data = response.data['data'] ?? response.data;
      final results = data['results'] as List? ?? data as List;
      return results
          .map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Address> createAddress(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(ApiEndpoints.addresses, data: body);
      final data = response.data['data'] ?? response.data;
      return Address.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Address> updateAddress(String id, Map<String, dynamic> body) async {
    try {
      final response =
          await _dio.patch(ApiEndpoints.addressDetail(id), data: body);
      final data = response.data['data'] ?? response.data;
      return Address.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await _dio.delete(ApiEndpoints.addressDetail(id));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> setDefaultAddress(String id) async {
    try {
      await _dio.post(ApiEndpoints.addressSetDefault(id));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException e) {
    if (e.error is AppException) return e.error as AppException;
    return const UnknownException();
  }
}

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AddressRepository(dio);
});
