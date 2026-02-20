import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/models/cart_model.dart';

class PriceBreakdown extends StatelessWidget {
  final Cart cart;

  const PriceBreakdown({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.sm + 4),

          // Subtotal
          _PriceRow(
            label: 'Subtotal (${cart.items.length} items)',
            value: cart.subtotalValue,
          ),

          // Delivery fee
          _PriceRow(
            label: 'Delivery Fee',
            value: cart.deliveryFeeValue,
            isFree: cart.deliveryFeeValue == 0,
          ),

          // Tax
          _PriceRow(
            label: 'Tax',
            value: cart.taxValue,
          ),

          // Coupon discount
          if (cart.hasCoupon)
            _PriceRow(
              label: 'Coupon Discount',
              value: cart.couponDiscountValue,
              isDiscount: true,
            ),

          // General discount
          if (cart.discountValue > 0)
            _PriceRow(
              label: 'Discount',
              value: cart.discountValue,
              isDiscount: true,
            ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.sm + 2),
            child: Divider(height: 1),
          ),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  '\u20B9${cart.totalValue.toStringAsFixed(0)}',
                  key: ValueKey(cart.total),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),

          // Savings message
          if (cart.discountValue > 0 || cart.couponDiscountValue > 0)
            Padding(
              padding: const EdgeInsets.only(top: AppDimensions.sm),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm + 4,
                  vertical: AppDimensions.sm,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.celebration_outlined,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Text(
                      'You save \u20B9${(cart.discountValue + cart.couponDiscountValue).toStringAsFixed(0)} on this order',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isDiscount;
  final bool isFree;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isDiscount = false,
    this.isFree = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            isFree
                ? 'FREE'
                : '${isDiscount ? '-' : ''}\u20B9${value.toStringAsFixed(0)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isFree
                  ? theme.colorScheme.primary
                  : isDiscount
                      ? theme.colorScheme.error
                      : null,
            ),
          ),
        ],
      ),
    );
  }
}
