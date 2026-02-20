import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';

class CouponInput extends StatefulWidget {
  final String? appliedCoupon;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<String> onApply;
  final VoidCallback onRemove;

  const CouponInput({
    super.key,
    this.appliedCoupon,
    this.isLoading = false,
    this.errorMessage,
    required this.onApply,
    required this.onRemove,
  });

  @override
  State<CouponInput> createState() => _CouponInputState();
}

class _CouponInputState extends State<CouponInput>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  late final AnimationController _animController;
  late final Animation<double> _shakeAnimation;
  String? _previousError;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticIn),
    );
  }

  @override
  void didUpdateWidget(CouponInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorMessage != null && widget.errorMessage != _previousError) {
      _animController.forward(from: 0);
    }
    _previousError = widget.errorMessage;
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasCoupon =
        widget.appliedCoupon != null && widget.appliedCoupon!.isNotEmpty;

    if (hasCoupon) {
      return _buildAppliedCoupon(context, theme);
    }

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final dx = _shakeAnimation.value *
            8 *
            ((_animController.value * 6).remainder(2) < 1 ? 1 : -1);
        return Transform.translate(
          offset: Offset(dx, 0),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                color: widget.errorMessage != null
                    ? theme.colorScheme.error.withValues(alpha: 0.5)
                    : theme.colorScheme.outline.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: AppDimensions.md),
                  child: Icon(
                    Icons.local_offer_outlined,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Enter coupon code',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.sm,
                        vertical: AppDimensions.md,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: TextButton(
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            final code = _controller.text.trim();
                            if (code.isNotEmpty) widget.onApply(code);
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.md,
                      ),
                    ),
                    child: widget.isLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : Text(
                            'Apply',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.errorMessage != null)
            Padding(
              padding:
                  const EdgeInsets.only(top: 6, left: AppDimensions.sm),
              child: Text(
                widget.errorMessage!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppliedCoupon(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm + 4,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coupon applied',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  widget.appliedCoupon!,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.isLoading ? null : widget.onRemove,
            icon: widget.isLoading
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.error,
                    ),
                  )
                : Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: theme.colorScheme.error,
                  ),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
