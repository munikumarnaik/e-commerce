import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../address/domain/models/address_model.dart';
import '../../../address/presentation/providers/address_provider.dart';
import '../../../address/presentation/screens/address_list_screen.dart';
import '../../../cart/domain/models/cart_model.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../providers/checkout_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-select the default address
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addressState = ref.read(addressProvider);
      final defaultAddr = addressState.defaultAddress;
      if (defaultAddr != null) {
        ref.read(checkoutProvider.notifier).selectAddress(defaultAddr.id);
      }
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final checkoutState = ref.watch(checkoutProvider);
    final cartState = ref.watch(cartProvider);
    final addressState = ref.watch(addressProvider);

    // Listen for success
    ref.listen<CheckoutState>(checkoutProvider, (prev, next) {
      if (next.status == CheckoutStatus.success && next.orderNumber != null) {
        // COD confirmed → order success
        context.go(
          RouteNames.orderSuccess,
          extra: {'order_number': next.orderNumber},
        );
      } else if (next.status == CheckoutStatus.pendingPayment &&
          next.orderNumber != null) {
        // ONLINE order created → payment screen
        context.push(
          RouteNames.payment,
          extra: {
            'order_number': next.orderNumber,
            'amount': next.orderTotal,
          },
        );
      } else if (next.status == CheckoutStatus.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            behavior: SnackBarBehavior.floating,
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    final cart = cartState.cart;

    // Find selected address object
    Address? selectedAddress;
    if (checkoutState.selectedAddressId != null) {
      try {
        selectedAddress = addressState.addresses.firstWhere(
          (a) => a.id == checkoutState.selectedAddressId,
        );
      } catch (_) {}
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppDimensions.md),
              children: [
                // Delivery Address
                _SectionHeader(
                  title: 'Delivery Address',
                  icon: Icons.location_on_rounded,
                  action: TextButton(
                    onPressed: () => _selectAddress(context),
                    child: Text(selectedAddress != null
                        ? 'Change'
                        : 'Select'),
                  ),
                ),
                if (selectedAddress != null)
                  _AddressPreview(address: selectedAddress)
                else
                  _EmptyAddressCard(
                    onTap: () => _selectAddress(context),
                  ),
                const SizedBox(height: AppDimensions.lg),

                // Order Items summary
                _SectionHeader(
                  title: 'Order Items (${cart.items.length})',
                  icon: Icons.shopping_bag_rounded,
                ),
                const SizedBox(height: AppDimensions.sm),
                ...cart.items.map((item) => _OrderItemTile(
                      name: item.product.name,
                      quantity: item.quantity,
                      price: item.totalPrice,
                      thumbnail: item.product.thumbnail,
                    )),
                const SizedBox(height: AppDimensions.lg),

                // Payment Method
                _SectionHeader(
                  title: 'Payment Method',
                  icon: Icons.payment_rounded,
                ),
                const SizedBox(height: AppDimensions.sm),
                _PaymentMethodSelector(
                  selected: checkoutState.paymentMethod,
                  onChanged: (method) => ref
                      .read(checkoutProvider.notifier)
                      .updatePaymentMethod(method),
                ),
                const SizedBox(height: AppDimensions.lg),

                // Customer Note
                _SectionHeader(
                  title: 'Order Note',
                  icon: Icons.note_alt_outlined,
                ),
                const SizedBox(height: AppDimensions.sm),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText:
                        'Any special instructions? (optional)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) =>
                      ref.read(checkoutProvider.notifier).updateNote(v),
                ),
                const SizedBox(height: AppDimensions.lg),

                // Price breakdown
                _PriceSummary(cart: cart),
                const SizedBox(height: AppDimensions.xl),
              ],
            ),
          ),

          // Place order bar
          _PlaceOrderBar(
            total: cart.totalValue,
            isProcessing: checkoutState.status == CheckoutStatus.processing,
            onPlaceOrder: () {
              ref.read(checkoutProvider.notifier).placeOrder(
                    couponCode: cart.couponCode,
                    cartTotal: cart.totalValue,
                  );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectAddress(BuildContext context) async {
    final selected = await Navigator.of(context).push<Address>(
      MaterialPageRoute(
        builder: (_) => const AddressListScreen(selectionMode: true),
      ),
    );
    if (selected != null && mounted) {
      ref.read(checkoutProvider.notifier).selectAddress(selected.id);
    }
  }
}

// ───── Widgets ─────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? action;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: AppDimensions.sm),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (action != null) action!,
      ],
    );
  }
}

class _AddressPreview extends StatelessWidget {
  final Address address;

  const _AddressPreview({required this.address});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeLabel = switch (address.addressType) {
      'HOME' => 'Home',
      'WORK' => 'Work',
      _ => 'Other',
    };

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    typeLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              address.fullName,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              '${address.addressLine1}\n${address.city}, ${address.state} ${address.postalCode}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            if (address.phone.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                address.phone,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyAddressCard extends StatelessWidget {
  final VoidCallback onTap;

  const _EmptyAddressCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(
            color: theme.colorScheme.outlineVariant,
            style: BorderStyle.solid),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_location_alt_rounded,
                  color: theme.colorScheme.primary),
              const SizedBox(width: AppDimensions.sm),
              Text(
                'Add delivery address',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  final String name;
  final int quantity;
  final String price;
  final String? thumbnail;

  const _OrderItemTile({
    required this.name,
    required this.quantity,
    required this.price,
    this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            child: thumbnail != null
                ? Image.network(
                    thumbnail!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 48,
                      height: 48,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.image_not_supported_outlined,
                          size: 20),
                    ),
                  )
                : Container(
                    width: 48,
                    height: 48,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.shopping_bag_outlined, size: 20),
                  ),
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  'Qty: $quantity',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\u20B9$price',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _PaymentMethodSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PaymentOption(
          label: 'Cash on Delivery',
          subtitle: 'Pay when your order arrives',
          icon: Icons.money_rounded,
          value: 'COD',
          groupValue: selected,
          onChanged: onChanged,
        ),
        const SizedBox(height: AppDimensions.sm),
        _PaymentOption(
          label: 'Online Payment',
          subtitle: 'Pay via UPI, Card, or Net Banking',
          icon: Icons.account_balance_wallet_rounded,
          value: 'ONLINE',
          groupValue: selected,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _PaymentOption({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = value == groupValue;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Row(
            children: [
              Icon(icon,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                    Text(subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        )),
                  ],
                ),
              ),
              Radio<String>(
                value: value,
                groupValue: groupValue,
                onChanged: (v) => onChanged(v!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  final Cart cart;

  const _PriceSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price Details',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppDimensions.sm),
            const Divider(),
            _PriceRow(label: 'Subtotal', value: cart.subtotal),
            if (cart.discountValue > 0)
              _PriceRow(
                label: 'Discount',
                value: '-${cart.discount}',
                isDiscount: true,
              ),
            if (cart.hasCoupon && cart.couponDiscountValue > 0)
              _PriceRow(
                label: 'Coupon (${cart.couponCode})',
                value: '-${cart.couponDiscount}',
                isDiscount: true,
              ),
            _PriceRow(label: 'Delivery Fee', value: cart.deliveryFee),
            _PriceRow(label: 'Tax', value: cart.tax),
            const Divider(),
            _PriceRow(
              label: 'Total',
              value: cart.total,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isDiscount;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isDiscount = false,
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
            style: isBold
                ? theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)
                : theme.textTheme.bodyMedium,
          ),
          Text(
            '\u20B9$value',
            style: isBold
                ? theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  )
                : theme.textTheme.bodyMedium?.copyWith(
                    color: isDiscount
                        ? Colors.green.shade700
                        : null,
                    fontWeight:
                        isDiscount ? FontWeight.w600 : null,
                  ),
          ),
        ],
      ),
    );
  }
}

class _PlaceOrderBar extends StatelessWidget {
  final double total;
  final bool isProcessing;
  final VoidCallback onPlaceOrder;

  const _PlaceOrderBar({
    required this.total,
    required this.isProcessing,
    required this.onPlaceOrder,
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
          Expanded(
            flex: 2,
            child: CustomButton(
              label: 'Place Order',
              onPressed: isProcessing ? null : onPlaceOrder,
              isLoading: isProcessing,
              icon: Icons.check_circle_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
