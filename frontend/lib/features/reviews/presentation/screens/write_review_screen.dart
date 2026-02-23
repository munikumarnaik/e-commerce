import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../providers/review_provider.dart';

class WriteReviewScreen extends ConsumerStatefulWidget {
  final String productSlug;
  final String productName;

  const WriteReviewScreen({
    super.key,
    required this.productSlug,
    required this.productName,
  });

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  int _selectedRating = 0;
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(writeReviewProvider.notifier).submitReview(
          productSlug: widget.productSlug,
          rating: _selectedRating,
          comment: _commentController.text.trim(),
          title: _titleController.text.trim().isNotEmpty
              ? _titleController.text.trim()
              : null,
        );

    if (success && mounted) {
      // Invalidate review list so it refreshes
      ref.invalidate(reviewListProvider(widget.productSlug));
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(writeReviewProvider);
    final theme = Theme.of(context);

    ref.listen<WriteReviewState>(writeReviewProvider, (prev, next) {
      if (next.status == WriteReviewStatus.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            behavior: SnackBarBehavior.floating,
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Write a Review')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Product name ──
              Text(
                widget.productName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms),

              const SizedBox(height: AppDimensions.lg),

              // ── Rating selector ──
              Center(
                child: Column(
                  children: [
                    Text(
                      'Tap to Rate',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _InteractiveStarRating(
                      rating: _selectedRating,
                      onChanged: (rating) {
                        setState(() => _selectedRating = rating);
                        HapticFeedback.lightImpact();
                      },
                    ),
                    const SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        _ratingLabel(_selectedRating),
                        key: ValueKey(_selectedRating),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _ratingColor(_selectedRating),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms)
                  .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),

              const SizedBox(height: AppDimensions.lg),

              // ── Title field ──
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Review Title (optional)',
                  hintText: 'Summarize your experience',
                  prefixIcon: const Icon(Icons.title_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLength: 200,
                textCapitalization: TextCapitalization.sentences,
              )
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppDimensions.md),

              // ── Comment field ──
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Your Review',
                  hintText: 'Tell others what you think about this product...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 56),
                    child: Icon(Icons.chat_outlined),
                  ),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 5,
                maxLength: 2000,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please write your review';
                  }
                  if (value.trim().length < 10) {
                    return 'Review must be at least 10 characters';
                  }
                  return null;
                },
              )
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppDimensions.xl),

              // ── Submit button ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: state.status == WriteReviewStatus.submitting
                      ? null
                      : _submitReview,
                  icon: state.status == WriteReviewStatus.submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(
                    state.status == WriteReviewStatus.submitting
                        ? 'Submitting...'
                        : 'Submit Review',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 400.ms)
                  .slideY(begin: 0.15, end: 0),

              const SizedBox(height: AppDimensions.xl),
            ],
          ),
        ),
      ),
    );
  }

  String _ratingLabel(int rating) {
    return switch (rating) {
      1 => 'Terrible',
      2 => 'Poor',
      3 => 'Average',
      4 => 'Good',
      5 => 'Excellent!',
      _ => '',
    };
  }

  Color _ratingColor(int rating) {
    return switch (rating) {
      1 => const Color(0xFFEF5350),
      2 => const Color(0xFFFF7043),
      3 => const Color(0xFFFFB300),
      4 => const Color(0xFF66BB6A),
      5 => const Color(0xFF4CAF50),
      _ => Colors.grey,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Interactive Star Rating
// ─────────────────────────────────────────────────────────────────────────────

class _InteractiveStarRating extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;

  const _InteractiveStarRating({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starValue = i + 1;
        final isSelected = starValue <= rating;

        return GestureDetector(
          onTap: () => onChanged(starValue),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutBack,
            padding: const EdgeInsets.all(6),
            child: AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(
                isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                size: 44,
                color: isSelected ? const Color(0xFFFFB300) : Colors.grey.shade400,
              ),
            ),
          ),
        );
      }),
    );
  }
}
