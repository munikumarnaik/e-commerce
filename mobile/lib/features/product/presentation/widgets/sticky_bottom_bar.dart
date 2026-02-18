import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';

class StickyBottomBar extends StatelessWidget {
  final bool isAvailable;
  final bool isLoading;
  final VoidCallback? onAddToCart;
  final VoidCallback? onBuyNow;

  const StickyBottomBar({
    super.key,
    this.isAvailable = true,
    this.isLoading = false,
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
                      onPressed: isLoading ? null : onAddToCart,
                      icon: isLoading
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.primary,
                              ),
                            )
                          : const Icon(Icons.shopping_cart_outlined, size: 20),
                      label: Text(
                        isLoading ? 'Adding...' : AppStrings.addToCart,
                      ),
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
                      onPressed: isLoading ? null : onBuyNow,
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
