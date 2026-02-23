import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../domain/models/review_model.dart';
import '../providers/review_provider.dart';

class ReviewsListScreen extends ConsumerStatefulWidget {
  final String productSlug;
  final String productName;

  const ReviewsListScreen({
    super.key,
    required this.productSlug,
    required this.productName,
  });

  @override
  ConsumerState<ReviewsListScreen> createState() => _ReviewsListScreenState();
}

class _ReviewsListScreenState extends ConsumerState<ReviewsListScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews & Ratings'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push(
              '/reviews/${widget.productSlug}/write',
              extra: {'product_name': widget.productName},
            ),
            icon: const Icon(Icons.rate_review_rounded, size: 18),
            label: const Text('Write'),
          ),
        ],
      ),
      body: _buildBody(state, theme),
    );
  }

  Widget _buildBody(ReviewListState state, ThemeData theme) {
    switch (state.status) {
      case ReviewListStatus.initial:
      case ReviewListStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case ReviewListStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: theme.colorScheme.error.withValues(alpha: 0.6)),
              const SizedBox(height: AppDimensions.md),
              Text('Failed to load reviews', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppDimensions.sm),
              ElevatedButton(
                onPressed: () => ref
                    .read(reviewListProvider(widget.productSlug).notifier)
                    .loadReviews(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case ReviewListStatus.loaded:
        return RefreshIndicator(
          onRefresh: () => ref
              .read(reviewListProvider(widget.productSlug).notifier)
              .loadReviews(),
          child: ListView(
            padding: const EdgeInsets.all(AppDimensions.md),
            children: [
              // ── Summary card ──
              _RatingSummaryCard(summary: state.summary)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.1, end: 0),

              const SizedBox(height: AppDimensions.md),

              // ── Filter & sort row ──
              _FilterSortRow(
                productSlug: widget.productSlug,
                selectedRating: state.selectedRating,
                selectedSort: state.selectedSort,
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: AppDimensions.md),

              // ── Reviews list ──
              if (state.reviews.isEmpty)
                _EmptyReviews(productSlug: widget.productSlug, productName: widget.productName)
              else
                ...state.reviews.asMap().entries.map((entry) {
                  return _ReviewCard(
                    review: entry.value,
                    productSlug: widget.productSlug,
                  )
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: 150 + entry.key * 60))
                      .slideY(begin: 0.05, end: 0);
                }),

              const SizedBox(height: AppDimensions.xl),
            ],
          ),
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Rating Summary Card
// ─────────────────────────────────────────────────────────────────────────────

class _RatingSummaryCard extends StatelessWidget {
  final ReviewsSummary summary;

  const _RatingSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxCount = summary.maxStarCount.clamp(1, 999999);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Row(
          children: [
            // ── Large rating number ──
            Column(
              children: [
                Text(
                  summary.averageRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 44,
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
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppDimensions.lg),

            // ── Star bars ──
            Expanded(
              child: Column(
                children: [
                  _StarBar(star: 5, count: summary.star5, max: maxCount, theme: theme),
                  _StarBar(star: 4, count: summary.star4, max: maxCount, theme: theme),
                  _StarBar(star: 3, count: summary.star3, max: maxCount, theme: theme),
                  _StarBar(star: 2, count: summary.star2, max: maxCount, theme: theme),
                  _StarBar(star: 1, count: summary.star1, max: maxCount, theme: theme),
                ],
              ),
            ),
          ],
        ),
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
          return const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB300));
        } else if (rating >= starValue - 0.5) {
          return const Icon(Icons.star_half_rounded, size: 16, color: Color(0xFFFFB300));
        } else {
          return Icon(Icons.star_outline_rounded, size: 16,
              color: Colors.grey.shade400);
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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            child: Text(
              '$star',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFB300)),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
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
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter & Sort Row
// ─────────────────────────────────────────────────────────────────────────────

class _FilterSortRow extends ConsumerWidget {
  final String productSlug;
  final int? selectedRating;
  final String? selectedSort;

  const _FilterSortRow({
    required this.productSlug,
    required this.selectedRating,
    required this.selectedSort,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(reviewListProvider(productSlug).notifier);

    return Column(
      children: [
        // ── Rating filter chips ──
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildChip('All', selectedRating == null, () => notifier.filterByRating(null), theme),
              for (int i = 5; i >= 1; i--)
                _buildChip('$i ★', selectedRating == i, () => notifier.filterByRating(i), theme),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // ── Sort options ──
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildSortChip('Newest', 'newest', notifier, theme),
              _buildSortChip('Highest', 'highest', notifier, theme),
              _buildSortChip('Lowest', 'lowest', notifier, theme),
              _buildSortChip('Helpful', 'helpful', notifier, theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, bool selected, VoidCallback onTap, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
        ),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        selectedColor: theme.colorScheme.primary,
        showCheckmark: false,
        side: BorderSide(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildSortChip(
      String label, String value, ReviewListNotifier notifier, ThemeData theme) {
    final isActive = selectedSort == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort_rounded, size: 14,
                color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        onPressed: () => notifier.sortBy(isActive ? null : value),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
        ),
        side: BorderSide(
          color: isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Review Card
// ─────────────────────────────────────────────────────────────────────────────

class _ReviewCard extends ConsumerWidget {
  final Review review;
  final String productSlug;

  const _ReviewCard({required this.review, required this.productSlug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: avatar, name, rating ──
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    backgroundImage: review.userAvatar != null && review.userAvatar!.isNotEmpty
                        ? NetworkImage(review.userAvatar!)
                        : null,
                    child: review.userAvatar == null || review.userAvatar!.isEmpty
                        ? Text(
                            review.userName.isNotEmpty
                                ? review.userName[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              review.userName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (review.isVerifiedPurchase) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.verified_rounded,
                                        size: 11, color: Color(0xFF4CAF50)),
                                    SizedBox(width: 3),
                                    Text(
                                      'Verified',
                                      style: TextStyle(
                                        color: Color(0xFF4CAF50),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(review.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _RatingBadge(rating: review.rating),
                ],
              ),

              const SizedBox(height: AppDimensions.sm),

              // ── Star row ──
              _StarRow(rating: review.rating.toDouble()),

              // ── Title ──
              if (review.title.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  review.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],

              // ── Comment ──
              const SizedBox(height: 6),
              Text(
                review.comment,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),

              // ── Review images ──
              if (review.images.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.sm),
                SizedBox(
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: review.images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          review.images[index].image,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 72,
                            height: 72,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.broken_image_rounded, size: 24),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              // ── Vendor response ──
              if (review.response != null) ...[
                const SizedBox(height: AppDimensions.sm),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.sm),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      left: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seller Response',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        review.response!.comment,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // ── Helpful button ──
              const SizedBox(height: AppDimensions.sm),
              Row(
                children: [
                  InkWell(
                    onTap: () => ref
                        .read(reviewListProvider(productSlug).notifier)
                        .toggleHelpful(review.id),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            review.hasVotedHelpful
                                ? Icons.thumb_up_rounded
                                : Icons.thumb_up_outlined,
                            size: 16,
                            color: review.hasVotedHelpful
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Helpful${review.helpfulCount > 0 ? ' (${review.helpfulCount})' : ''}',
                            style: TextStyle(
                              fontSize: 12,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$rating',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.star_rounded, size: 12, color: Colors.white),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty Reviews
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyReviews extends StatelessWidget {
  final String productSlug;
  final String productName;

  const _EmptyReviews({required this.productSlug, required this.productName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.xl),
        child: Column(
          children: [
            Icon(Icons.rate_review_outlined,
                size: 64, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
            const SizedBox(height: AppDimensions.md),
            Text(
              'No reviews yet',
              style: theme.textTheme.titleMedium?.copyWith(
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
            const SizedBox(height: AppDimensions.md),
            ElevatedButton.icon(
              onPressed: () => context.push(
                '/reviews/$productSlug/write',
                extra: {'product_name': productName},
              ),
              icon: const Icon(Icons.edit_rounded, size: 16),
              label: const Text('Write a Review'),
            ),
          ],
        ),
      ),
    );
  }
}
