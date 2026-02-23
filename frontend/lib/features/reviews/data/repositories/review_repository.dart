import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/review_model.dart';

class ReviewRepository {
  final Dio _dio;

  ReviewRepository(this._dio);

  Future<List<Review>> getReviews(String productSlug, {Map<String, dynamic>? filters}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.reviewList(productSlug),
        queryParameters: filters,
      );
      final data = response.data['data'] ?? response.data;
      final results = data['results'] as List? ?? data as List;
      return results
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ReviewsSummary> getReviewsSummary(String productSlug) async {
    try {
      final response = await _dio.get(ApiEndpoints.reviewSummary(productSlug));
      final data = response.data['data'] ?? response.data;
      return ReviewsSummary.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Review> createReview({
    required String productSlug,
    required int rating,
    required String comment,
    String? title,
    List<String>? imageUrls,
  }) async {
    try {
      final body = <String, dynamic>{
        'product_slug': productSlug,
        'rating': rating,
        'comment': comment,
      };
      if (title != null && title.isNotEmpty) body['title'] = title;
      if (imageUrls != null && imageUrls.isNotEmpty) body['image_urls'] = imageUrls;

      final response = await _dio.post(ApiEndpoints.reviewCreate, data: body);
      final data = response.data['data'] ?? response.data;
      return Review.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      await _dio.delete(ApiEndpoints.reviewDelete(reviewId));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> toggleHelpful(String reviewId) async {
    try {
      final response = await _dio.post(ApiEndpoints.reviewHelpful(reviewId));
      final data = response.data['data'] ?? {};
      return data['is_helpful'] as bool? ?? false;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException e) {
    if (e.error is AppException) return e.error as AppException;
    return const UnknownException();
  }
}

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ReviewRepository(dio);
});
