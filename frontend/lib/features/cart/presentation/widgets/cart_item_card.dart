import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/cached_image.dart';
import '../../domain/models/cart_item_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFood = item.product.productType == 'FOOD';

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      confirmDismiss: (_) async {
        HapticFeedback.mediumImpact();
        return true;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimensions.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline_rounded,
              color: theme.colorScheme.onError,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              'Remove',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onError,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.sm + 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              child: CachedImage(
                imageUrl: item.product.thumbnail,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: AppDimensions.sm + 4),

            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand & type badge row
                  Row(
                    children: [
                      if (item.product.brand != null)
                        Expanded(
                          child: Text(
                            item.product.brand!.name,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isFood
                              ? theme.colorScheme.primary.withValues(alpha: 0.1)
                              : theme.colorScheme.secondary
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isFood ? 'Food' : 'Clothing',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isFood
                                ? theme.colorScheme.primary
                                : theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Product name
                  Text(
                    item.product.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Variant info
                  if (item.variant != null) ...[
                    const SizedBox(height: 4),
                    _VariantChips(variant: item.variant!),
                  ],

                  const SizedBox(height: AppDimensions.sm),

                  // Price & quantity row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\u20B9${item.totalPriceValue.toStringAsFixed(0)}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (item.quantity > 1)
                            Text(
                              '\u20B9${item.unitPriceValue.toStringAsFixed(0)} each',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),

                      // Quantity controls
                      _QuantitySelector(
                        quantity: item.quantity,
                        onChanged: onQuantityChanged,
                        maxQuantity: item.product.stockQuantity,
                      ),
                    ],
                  ),

                  // Stock warning
                  if (item.product.stockQuantity > 0 &&
                      item.product.stockQuantity <= 5)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Only ${item.product.stockQuantity} left in stock',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VariantChips extends StatelessWidget {
  final CartVariant variant;

  const _VariantChips({required this.variant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chips = <Widget>[];

    if (variant.size.isNotEmpty) {
      chips.add(_buildChip(context, 'Size: ${variant.size}'));
    }
    if (variant.color.isNotEmpty) {
      chips.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (variant.colorHex != null)
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: _parseHexColor(variant.colorHex!),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
              ),
            _buildChip(context, variant.color),
          ],
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: 6, children: chips);
  }

  Widget _buildChip(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: 11,
        ),
      ),
    );
  }

  Color _parseHexColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('FF');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int maxQuantity;

  const _QuantitySelector({
    required this.quantity,
    required this.onChanged,
    this.maxQuantity = 99,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            context,
            icon: quantity == 1
                ? Icons.delete_outline_rounded
                : Icons.remove_rounded,
            onTap: () {
              HapticFeedback.lightImpact();
              onChanged(quantity - 1);
            },
            isDestructive: quantity == 1,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 36),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                '$quantity',
                key: ValueKey(quantity),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildButton(
            context,
            icon: Icons.add_rounded,
            onTap: quantity < maxQuantity || maxQuantity == 0
                ? () {
                    HapticFeedback.lightImpact();
                    onChanged(quantity + 1);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 18,
          color: isDestructive
              ? theme.colorScheme.error
              : onTap != null
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
