import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../domain/models/review_model.dart';
import '../providers/review_provider.dart';

/// Inline reviews section to be embedded in the product detail screen.
class ProductReviewsSection extends ConsumerStatefulWidget {
  final String productSlug;
  final String productName;

  const ProductReviewsSection({
    super.key,
    required this.productSlug,
    required this.productName,
  });

  @override
  ConsumerState<ProductReviewsSection> createState() =>
      _ProductReviewsSectionState();
}

class _ProductReviewsSectionState
    extends ConsumerState<ProductReviewsSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewListProvider(widget.productSlug).notifier).loadReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewListProvider(widget.productSlug));
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: AppDimensions.sm),

          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Reviews & Ratings',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => context.push(
                  '/reviews/${widget.productSlug}/write',
                  extra: {'product_name': widget.productName},
                ),
                icon: const Icon(Icons.rate_review_rounded, size: 16),
                label: const Text('Write Review'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.sm),

          // Content based on state
          _buildContent(state, theme),
        ],
      ),
    );
  }

  Widget _buildContent(ReviewListState state, ThemeData theme) {
    switch (state.status) {
      case ReviewListStatus.initial:
      case ReviewListStatus.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.lg),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );

      case ReviewListStatus.error:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
          child: Center(
            child: Column(
              children: [
                Text('Failed to load reviews',
                    style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ref
                      .read(
                          reviewListProvider(widget.productSlug).notifier)
                      .loadReviews(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );

      case ReviewListStatus.loaded:
        if (state.reviews.isEmpty) {
          return _buildEmptyReviews(theme);
        }
        return _buildLoadedReviews(state, theme);
    }
  }

  Widget _buildEmptyReviews(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.lg),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.rate_review_outlined,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.4)),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'No reviews yet',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Be the first to review this product!',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedReviews(ReviewListState state, ThemeData theme) {
    return Column(
      children: [
        // Summary card
        _InlineSummaryCard(summary: state.summary)
            .animate()
            .fadeIn(duration: 300.ms),

        const SizedBox(height: AppDimensions.md),

        // Show first 3 reviews
        ...state.reviews.take(3).map((review) {
          return _InlineReviewCard(
            review: review,
            productSlug: widget.productSlug,
          ).animate().fadeIn(duration: 300.ms);
        }),

        // "View All" button if more reviews exist
        if (state.reviews.length > 3 || state.summary.totalReviews > 3)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.sm),
            child: TextButton(
              onPressed: () => context.push(
                '/reviews/${widget.productSlug}',
                extra: {'product_name': widget.productName},
              ),
              child: Text(
                'View All ${state.summary.totalReviews} Reviews',
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Inline Summary Card (compact version)
// ─────────────────────────────────────────────────────────────────────────────

class _InlineSummaryCard extends StatelessWidget {
  final ReviewsSummary summary;

  const _InlineSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxCount = summary.maxStarCount.clamp(1, 999999);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Rating number
          Column(
            children: [
              Text(
                summary.averageRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              _StarRow(rating: summary.averageRating),
              const SizedBox(height: 4),
              Text(
                '${summary.totalReviews} review${summary.totalReviews != 1 ? 's' : ''}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppDimensions.md),

          // Star bars
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final star = 5 - i;
                final count = [
                  summary.star1,
                  summary.star2,
                  summary.star3,
                  summary.star4,
                  summary.star5,
                ][star - 1];
                return _StarBar(
                    star: star, count: count, max: maxCount, theme: theme);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final double rating;

  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starValue = i + 1;
        if (rating >= starValue) {
          return const Icon(Icons.star_rounded,
              size: 14, color: Color(0xFFFFB300));
        } else if (rating >= starValue - 0.5) {
          return const Icon(Icons.star_half_rounded,
              size: 14, color: Color(0xFFFFB300));
        } else {
          return Icon(Icons.star_outline_rounded,
              size: 14, color: Colors.grey.shade400);
        }
      }),
    );
  }
}

class _StarBar extends StatelessWidget {
  final int star;
  final int count;
  final int max;
  final ThemeData theme;

  const _StarBar({
    required this.star,
    required this.count,
    required this.max,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = max > 0 ? count / max : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        children: [
          SizedBox(
            width: 12,
            child: Text(
              '$star',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ),
          const Icon(Icons.star_rounded, size: 10, color: Color(0xFFFFB300)),
          const SizedBox(width: 4),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: fraction,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(
                  star >= 4
                      ? const Color(0xFF4CAF50)
                      : star == 3
                          ? const Color(0xFFFFB300)
                          : const Color(0xFFEF5350),
                ),
                minHeight: 5,
              ),
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 22,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Inline Review Card (compact version)
// ─────────────────────────────────────────────────────────────────────────────

class _InlineReviewCard extends ConsumerWidget {
  final Review review;
  final String productSlug;

  const _InlineReviewCard({required this.review, required this.productSlug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: name + rating badge
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage:
                      review.userAvatar != null && review.userAvatar!.isNotEmpty
                          ? NetworkImage(review.userAvatar!)
                          : null,
                  child:
                      review.userAvatar == null || review.userAvatar!.isEmpty
                          ? Text(
                              review.userName.isNotEmpty
                                  ? review.userName[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            )
                          : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review.userName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (review.isVerifiedPurchase) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.verified_rounded,
                                size: 12, color: Color(0xFF4CAF50)),
                          ],
                        ],
                      ),
                      Text(
                        _formatDate(review.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                _RatingBadge(rating: review.rating),
              ],
            ),

            const SizedBox(height: 8),

            // Title
            if (review.title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  review.title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Comment (truncated)
            Text(
              review.comment,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            // Helpful
            const SizedBox(height: 6),
            Row(
              children: [
                InkWell(
                  onTap: () => ref
                      .read(reviewListProvider(productSlug).notifier)
                      .toggleHelpful(review.id),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          review.hasVotedHelpful
                              ? Icons.thumb_up_rounded
                              : Icons.thumb_up_outlined,
                          size: 14,
                          color: review.hasVotedHelpful
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Helpful${review.helpfulCount > 0 ? ' (${review.helpfulCount})' : ''}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: review.hasVotedHelpful
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: review.hasVotedHelpful
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

class _RatingBadge extends StatelessWidget {
  final int rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    final color = rating >= 4
        ? const Color(0xFF4CAF50)
        : rating == 3
            ? const Color(0xFFFFB300)
            : const Color(0xFFEF5350);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$rating',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.star_rounded, size: 10, color: Colors.white),
        ],
      ),
    );
  }
}
