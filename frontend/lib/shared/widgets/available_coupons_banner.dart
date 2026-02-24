import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../providers/available_coupons_provider.dart';

/// A horizontal scrollable list of available coupon chips.
/// Shows coupon code, discount info, and tap-to-copy behavior.
class AvailableCouponsBanner extends StatelessWidget {
  final List<AvailableCoupon> coupons;
  final ValueChanged<String>? onApply;

  const AvailableCouponsBanner({
    super.key,
    required this.coupons,
    this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    if (coupons.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              Icon(Icons.local_offer_rounded,
                  size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'Available Offers',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: coupons.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) => _CouponChip(
              coupon: coupons[i],
              onApply: onApply,
            ),
          ),
        ),
      ],
    );
  }
}

class _CouponChip extends StatelessWidget {
  final AvailableCoupon coupon;
  final ValueChanged<String>? onApply;

  const _CouponChip({required this.coupon, this.onApply});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPercentage = coupon.discountType == 'PERCENTAGE';

    return GestureDetector(
      onTap: () {
        if (onApply != null) {
          onApply!(coupon.code);
        } else {
          Clipboard.setData(ClipboardData(text: coupon.code));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Coupon code "${coupon.code}" copied!'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isPercentage
                ? [
                    const Color(0xFF6366F1).withValues(alpha: 0.08),
                    const Color(0xFF818CF8).withValues(alpha: 0.04),
                  ]
                : [
                    const Color(0xFFF59E0B).withValues(alpha: 0.08),
                    const Color(0xFFFBBF24).withValues(alpha: 0.04),
                  ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPercentage
                ? const Color(0xFF6366F1).withValues(alpha: 0.2)
                : const Color(0xFFF59E0B).withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Discount label
            Text(
              coupon.discountLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: isPercentage
                    ? const Color(0xFF6366F1)
                    : const Color(0xFFD97706),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),

            // Coupon code
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color:
                      theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    coupon.code,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    onApply != null
                        ? Icons.arrow_forward_rounded
                        : Icons.copy_rounded,
                    size: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),

            // Min order
            if (coupon.minOrderValue > 0)
              Text(
                'Min order ₹${coupon.minOrderValue.toStringAsFixed(0)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
