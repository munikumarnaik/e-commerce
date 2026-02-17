import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

class StickyBottomBar extends StatelessWidget {
  final bool isAvailable;
  final VoidCallback? onAddToCart;
  final VoidCallback? onBuyNow;

  const StickyBottomBar({
    super.key,
    this.isAvailable = true,
    this.onAddToCart,
    this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.md,
        AppDimensions.sm,
        AppDimensions.md,
        AppDimensions.sm + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: isAvailable
          ? Row(
              children: [
                // Add to Cart
                Expanded(
                  child: SizedBox(
                    height: AppDimensions.buttonHeight,
                    child: OutlinedButton.icon(
                      onPressed: onAddToCart,
                      icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                      label: const Text(AppStrings.addToCart),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.buttonRadius),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                // Buy Now
                Expanded(
                  child: SizedBox(
                    height: AppDimensions.buttonHeight,
                    child: FilledButton.icon(
                      onPressed: onBuyNow,
                      icon: const Icon(Icons.flash_on_rounded, size: 20),
                      label: const Text(AppStrings.buyNow),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.buttonRadius),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: FilledButton(
                onPressed: null,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.buttonRadius),
                  ),
                ),
                child: const Text(AppStrings.outOfStock),
              ),
            ),
    );
  }
}
