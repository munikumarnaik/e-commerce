import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../product/domain/models/brand_model.dart';
import '../../../product/domain/models/category_model.dart';
import '../../../product/domain/models/product_model.dart';

part 'search_result_model.freezed.dart';
part 'search_result_model.g.dart';

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required String query,
    @Default([]) List<Product> products,
    @Default([]) List<Category> categories,
    @Default([]) List<Brand> brands,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}
