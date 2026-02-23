import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/review_repository.dart';
import '../../domain/models/review_model.dart';

// ── Review list for a product ──

enum ReviewListStatus { initial, loading, loaded, error }

class ReviewListState {
  final ReviewListStatus status;
  final List<Review> reviews;
  final ReviewsSummary summary;
  final String? error;
  final String? selectedSort;
  final int? selectedRating;

  const ReviewListState({
    this.status = ReviewListStatus.initial,
    this.reviews = const [],
    this.summary = const ReviewsSummary(),
    this.error,
    this.selectedSort,
    this.selectedRating,
  });

  ReviewListState copyWith({
    ReviewListStatus? status,
    List<Review>? reviews,
    ReviewsSummary? summary,
    String? error,
    String? selectedSort,
    int? selectedRating,
    bool clearRating = false,
    bool clearSort = false,
  }) {
    return ReviewListState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      summary: summary ?? this.summary,
      error: error,
      selectedSort: clearSort ? null : (selectedSort ?? this.selectedSort),
      selectedRating: clearRating ? null : (selectedRating ?? this.selectedRating),
    );
  }
}

class ReviewListNotifier extends StateNotifier<ReviewListState> {
  final ReviewRepository _repository;
  final String productSlug;

  ReviewListNotifier(this._repository, this.productSlug)
      : super(const ReviewListState());

  Future<void> loadReviews() async {
    state = state.copyWith(status: ReviewListStatus.loading);
    try {
      final filters = <String, dynamic>{};
      if (state.selectedRating != null) filters['rating'] = state.selectedRating;
      if (state.selectedSort != null) filters['sort'] = state.selectedSort;

      final results = await Future.wait([
        _repository.getReviews(productSlug, filters: filters),
        _repository.getReviewsSummary(productSlug),
      ]);

      state = state.copyWith(
        status: ReviewListStatus.loaded,
        reviews: results[0] as List<Review>,
        summary: results[1] as ReviewsSummary,
      );
    } catch (e) {
      state = state.copyWith(
        status: ReviewListStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> filterByRating(int? rating) async {
    if (rating == null) {
      state = state.copyWith(clearRating: true);
    } else {
      state = state.copyWith(selectedRating: rating);
    }
    await loadReviews();
  }

  Future<void> sortBy(String? sort) async {
    if (sort == null) {
      state = state.copyWith(clearSort: true);
    } else {
      state = state.copyWith(selectedSort: sort);
    }
    await loadReviews();
  }

  Future<bool> toggleHelpful(String reviewId) async {
    try {
      final isHelpful = await _repository.toggleHelpful(reviewId);
      // Update the review in our local state
      final updated = state.reviews.map((r) {
        if (r.id == reviewId) {
          return Review(
            id: r.id,
            userName: r.userName,
            userAvatar: r.userAvatar,
            rating: r.rating,
            title: r.title,
            comment: r.comment,
            isVerifiedPurchase: r.isVerifiedPurchase,
            helpfulCount: isHelpful ? r.helpfulCount + 1 : r.helpfulCount - 1,
            images: r.images,
            response: r.response,
            hasVotedHelpful: isHelpful,
            createdAt: r.createdAt,
          );
        }
        return r;
      }).toList();
      state = state.copyWith(reviews: updated);
      return isHelpful;
    } catch (_) {
      return false;
    }
  }
}

final reviewListProvider = StateNotifierProvider.autoDispose
    .family<ReviewListNotifier, ReviewListState, String>((ref, productSlug) {
  final repository = ref.watch(reviewRepositoryProvider);
  return ReviewListNotifier(repository, productSlug);
});

// ── Write review state ──

enum WriteReviewStatus { idle, submitting, success, error }

class WriteReviewState {
  final WriteReviewStatus status;
  final String? error;

  const WriteReviewState({
    this.status = WriteReviewStatus.idle,
    this.error,
  });

  WriteReviewState copyWith({WriteReviewStatus? status, String? error}) {
    return WriteReviewState(
      status: status ?? this.status,
      error: error,
    );
  }
}

class WriteReviewNotifier extends StateNotifier<WriteReviewState> {
  final ReviewRepository _repository;

  WriteReviewNotifier(this._repository) : super(const WriteReviewState());

  Future<bool> submitReview({
    required String productSlug,
    required int rating,
    required String comment,
    String? title,
  }) async {
    state = state.copyWith(status: WriteReviewStatus.submitting, error: null);
    try {
      await _repository.createReview(
        productSlug: productSlug,
        rating: rating,
        comment: comment,
        title: title,
      );
      state = state.copyWith(status: WriteReviewStatus.success);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: WriteReviewStatus.error,
        error: e.toString().replaceAll(RegExp(r'Exception:|AppException:'), '').trim(),
      );
      return false;
    }
  }

  void reset() {
    state = const WriteReviewState();
  }
}

final writeReviewProvider =
    StateNotifierProvider.autoDispose<WriteReviewNotifier, WriteReviewState>(
        (ref) {
  return WriteReviewNotifier(ref.watch(reviewRepositoryProvider));
});
