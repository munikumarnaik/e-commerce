import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/coupon_input.dart';
import '../widgets/price_breakdown.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cartState.status == CartStatus.loaded && cartState.cart.isNotEmpty
              ? 'Cart (${cartState.cart.items.length})'
              : 'Cart',
        ),
        actions: [
          if (cartState.status == CartStatus.loaded &&
              cartState.cart.isNotEmpty)
            TextButton(
              onPressed: () => _showClearCartDialog(context, ref),
              child: Text(
                'Clear All',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(context, ref, cartState, theme),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CartState cartState,
    ThemeData theme,
  ) {
    switch (cartState.status) {
      case CartStatus.initial:
      case CartStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case CartStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: theme.colorScheme.error.withValues(alpha: 0.6),
              ),
              const SizedBox(height: AppDimensions.md),
              Text(
                'Failed to load cart',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppDimensions.sm),
              CustomButton(
                label: 'Retry',
                onPressed: () => ref.read(cartProvider.notifier).loadCart(),
                fullWidth: false,
                variant: ButtonVariant.outlined,
              ),
            ],
          ),
        );

      case CartStatus.loaded:
        if (cartState.cart.isEmpty) {
          return EmptyStateWidget(
            title: 'Your cart is empty',
            subtitle:
                'Looks like you haven\'t added anything yet.\nStart browsing and add items you love!',
            icon: Icons.shopping_cart_outlined,
            actionLabel: 'Start Shopping',
            onAction: () {
              // Navigate to home — the bottom nav already handles this
            },
          );
        }

        return _buildCartContent(context, ref, cartState, theme);
    }
  }

  Widget _buildCartContent(
    BuildContext context,
    WidgetRef ref,
    CartState cartState,
    ThemeData theme,
  ) {
    return Column(
      children: [
        // Scrollable cart items
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.read(cartProvider.notifier).loadCart(),
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.md),
              children: [
                // Cart items
                ...List.generate(cartState.cart.items.length, (index) {
                  final item = cartState.cart.items[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < cartState.cart.items.length - 1
                          ? AppDimensions.sm + 4
                          : 0,
                    ),
                    child: CartItemCard(
                      item: item,
                      onQuantityChanged: (newQty) {
                        if (newQty < 1) {
                          ref.read(cartProvider.notifier).removeItem(item.id);
                        } else {
                          ref
                              .read(cartProvider.notifier)
                              .updateQuantity(item.id, newQty);
                        }
                      },
                      onRemove: () {
                        HapticFeedback.mediumImpact();
                        ref.read(cartProvider.notifier).removeItem(item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.product.name} removed'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                ref.read(cartProvider.notifier).addToCart(
                                      productId: item.product.id,
                                      variantId: item.variant?.id,
                                      quantity: item.quantity,
                                    );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),

                const SizedBox(height: AppDimensions.lg),

                // Coupon input
                CouponInput(
                  appliedCoupon: cartState.cart.couponCode,
                  isLoading: cartState.isCouponLoading,
                  errorMessage: cartState.couponError,
                  onApply: (code) {
                    ref.read(cartProvider.notifier).applyCoupon(code);
                  },
                  onRemove: () {
                    ref.read(cartProvider.notifier).removeCoupon();
                  },
                ),

                const SizedBox(height: AppDimensions.md),

                // Price breakdown
                PriceBreakdown(cart: cartState.cart),

                // Bottom padding for the sticky button
                const SizedBox(height: AppDimensions.lg),
              ],
            ),
          ),
        ),

        // Sticky checkout bar
        _CheckoutBar(
          total: cartState.cart.totalValue,
          itemCount: cartState.cart.items.length,
          onCheckout: () {
            context.push(RouteNames.checkout);
          },
        ),
      ],
    );
  }

  void _showClearCartDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(cartProvider.notifier).clearCart();
            },
            child: Text(
              'Clear',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final double total;
  final int itemCount;
  final VoidCallback onCheckout;

  const _CheckoutBar({
    required this.total,
    required this.itemCount,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: AppDimensions.md,
        right: AppDimensions.md,
        top: AppDimensions.md,
        bottom: MediaQuery.of(context).padding.bottom + AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Total price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\u20B9${total.toStringAsFixed(0)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Checkout button
          Expanded(
            flex: 2,
            child: CustomButton(
              label: 'Proceed to Checkout',
              onPressed: onCheckout,
              icon: Icons.arrow_forward_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
