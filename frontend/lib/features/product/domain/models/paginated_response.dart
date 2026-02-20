class PaginatedResponse<T> {
  final int count;
  final String? next;
  final String? previous;
  final int page;
  final int pageSize;
  final int totalPages;
  final List<T> results;

  const PaginatedResponse({
    required this.count,
    this.next,
    this.previous,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.results,
  });

  bool get hasMore => next != null;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final data = json;
    return PaginatedResponse<T>(
      count: data['count'] as int? ?? 0,
      next: data['next'] as String?,
      previous: data['previous'] as String?,
      page: data['page'] as int? ?? 1,
      pageSize: data['page_size'] as int? ?? 20,
      totalPages: data['total_pages'] as int? ?? 1,
      results: (data['results'] as List<dynamic>?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
