import 'package:flutter/material.dart';

import '../../domain/models/coupon_model.dart';

class CouponCard extends StatelessWidget {
  final CouponModel coupon;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CouponCard({
    super.key,
    required this.coupon,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPercentage = coupon.discountType == 'PERCENTAGE';
    final accentColor = coupon.isActive && coupon.isValid
        ? const Color(0xFF10B981)
        : const Color(0xFFEF4444);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
            child: Row(
              children: [
                _DiscountBadge(
                  label: coupon.discountLabel,
                  isPercentage: isPercentage,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coupon.code,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        coupon.statusLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: coupon.isActive,
                  onChanged: (_) => onToggle(),
                  activeColor: const Color(0xFF10B981),
                ),
              ],
            ),
          ),

          const Divider(height: 16),

          // ── Details chips ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                CouponDetailChip(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Min ₹${coupon.minOrderValue.toStringAsFixed(0)}',
                ),
                CouponDetailChip(
                  icon: Icons.people_outlined,
                  label:
                      '${coupon.usageCount}/${coupon.maxUsage ?? '∞'} used',
                ),
                if (coupon.maxDiscount != null)
                  CouponDetailChip(
                    icon: Icons.money_off_outlined,
                    label:
                        'Max ₹${coupon.maxDiscount!.toStringAsFixed(0)}',
                  ),
              ],
            ),
          ),

          // ── Applicable products ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: coupon.applicableProducts.isNotEmpty
                ? Row(
                    children: [
                      Icon(Icons.inventory_2_outlined,
                          size: 12, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          coupon.applicableProducts
                              .map((p) => p.name)
                              .join(', '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Text(
                        '${coupon.applicableProducts.length} product${coupon.applicableProducts.length > 1 ? 's' : ''}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Icon(Icons.all_inclusive_rounded,
                          size: 12, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 5),
                      Text(
                        'Applies to all products',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
          ),

          // ── Footer: dates + actions ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 8, 10),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 12,
                    color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '${_fmt(coupon.validFrom)} — ${_fmt(coupon.validUntil)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: onEdit,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  color: const Color(0xFFEF4444),
                  onPressed: onDelete,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}

// ── Discount badge ──────────────────────────────
class _DiscountBadge extends StatelessWidget {
  final String label;
  final bool isPercentage;

  const _DiscountBadge({required this.label, required this.isPercentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPercentage
              ? [const Color(0xFF6366F1), const Color(0xFF818CF8)]
              : [const Color(0xFFF59E0B), const Color(0xFFFBBF24)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

// ── Detail chip ─────────────────────────────────
class CouponDetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const CouponDetailChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
