import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/route_names.dart';
import '../providers/payment_provider.dart';

/// Payment method option model used in the selection grid.
class _PaymentMethodOption {
  final String id;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _PaymentMethodOption({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

const _paymentMethods = [
  _PaymentMethodOption(
    id: 'upi',
    label: 'UPI',
    subtitle: 'Instant & Free',
    icon: Icons.phone_android_rounded,
    color: Color(0xFF4CAF50),
  ),
  _PaymentMethodOption(
    id: 'card',
    label: 'Card',
    subtitle: 'Debit / Credit',
    icon: Icons.credit_card_rounded,
    color: Color(0xFF2196F3),
  ),
  _PaymentMethodOption(
    id: 'netbanking',
    label: 'Net Banking',
    subtitle: 'All major banks',
    icon: Icons.account_balance_rounded,
    color: Color(0xFF9C27B0),
  ),
  _PaymentMethodOption(
    id: 'wallet',
    label: 'Wallet',
    subtitle: 'Paytm, PhonePe…',
    icon: Icons.account_balance_wallet_rounded,
    color: Color(0xFFFF9800),
  ),
];

class PaymentScreen extends ConsumerStatefulWidget {
  final String orderNumber;
  final double amount;

  const PaymentScreen({
    required this.orderNumber,
    required this.amount,
    super.key,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen>
    with SingleTickerProviderStateMixin {
  late Razorpay _razorpay;
  String _selectedMethodId = 'upi';
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _pulseController.dispose();
    super.dispose();
  }

  // ── Razorpay SDK callbacks ──

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ref.read(paymentProvider.notifier).verifyAndComplete(
          razorpayOrderId: response.orderId ?? '',
          razorpayPaymentId: response.paymentId ?? '',
          razorpaySignature: response.signature ?? '',
        );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    final msg = response.message ?? 'Payment failed. Please try again.';
    ref.read(paymentProvider.notifier).setFailed(msg);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet (PhonePe, Paytm, etc.) selected.
    // Razorpay handles the rest; no extra action needed here.
  }

  // ── Razorpay open ──

  void _openRazorpay() {
    final initResult = ref.read(paymentProvider).initiateResult;
    if (initResult?.razorpay == null) return;

    final rz = initResult!.razorpay!;
    final options = <String, dynamic>{
      'key': rz.keyId,
      'amount': rz.amount, // already in paise from backend
      'currency': rz.currency,
      'order_id': rz.orderId,
      'name': 'ShopVerse',
      'description': 'Order #${widget.orderNumber}',
      'prefill': {
        'contact': '',
        'email': '',
      },
      'external': {
        'wallets': ['paytm', 'phonepe'],
      },
      'theme': {
        'color': '#1A1A2E',
      },
      'method': {
        _selectedMethodId: '1',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      ref.read(paymentProvider.notifier).setFailed(e.toString());
    }
  }

  // ── Pay button tap ──

  void _onPayTapped() {
    HapticFeedback.mediumImpact();
    ref.read(paymentProvider.notifier).initiatePayment(widget.orderNumber);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentProvider);

    // Navigate based on state changes
    ref.listen<PaymentState>(paymentProvider, (prev, next) {
      if (next.status == PaymentFlowStatus.awaitingPayment &&
          next.initiateResult?.isOnlinePayment == true) {
        // Open Razorpay SDK after next frame
        WidgetsBinding.instance.addPostFrameCallback((_) => _openRazorpay());
      } else if (next.status == PaymentFlowStatus.success) {
        HapticFeedback.heavyImpact();
        context.go(RouteNames.paymentSuccess, extra: {
          'order_number': widget.orderNumber,
          'transaction_id': next.transactionId ?? '',
          'amount': widget.amount,
        });
      } else if (next.status == PaymentFlowStatus.failed) {
        context.go(RouteNames.paymentFailure, extra: {
          'order_number': widget.orderNumber,
          'error': next.error ?? 'Payment failed.',
          'amount': widget.amount,
        });
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1E),
        appBar: _buildAppBar(context),
        body: state.isLoading
            ? _buildLoadingState(state)
            : _buildBody(context, state),
        bottomNavigationBar:
            state.isLoading ? null : _buildPayButton(context, state),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0F0F1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_rounded, size: 16, color: Color(0xFF4CAF50)),
          const SizedBox(width: 6),
          const Text(
            'Secure Payment',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(PaymentState state) {
    final label = state.status == PaymentFlowStatus.initiating
        ? 'Setting up secure payment…'
        : 'Verifying your payment…';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) => Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A1A2E),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4776E6)
                        .withValues(alpha: 0.3 + _pulseController.value * 0.4),
                    blurRadius: 24 + _pulseController.value * 16,
                    spreadRadius: 4 + _pulseController.value * 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_rounded,
                size: 40,
                color: Color(0xFF4776E6),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          const SizedBox(
            width: 160,
            child: LinearProgressIndicator(
              backgroundColor: Color(0xFF1A1A2E),
              color: Color(0xFF4776E6),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, PaymentState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Amount card ──
          _AmountCard(
            orderNumber: widget.orderNumber,
            amount: widget.amount,
            pulseController: _pulseController,
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),

          const SizedBox(height: AppDimensions.lg),

          // ── Section label ──
          const Text(
            'SELECT PAYMENT METHOD',
            style: TextStyle(
              color: Color(0xFF9B9BB5),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: AppDimensions.sm),

          // ── Payment method grid ──
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: _paymentMethods.length,
            itemBuilder: (context, index) {
              final method = _paymentMethods[index];
              return _PaymentMethodCard(
                method: method,
                isSelected: _selectedMethodId == method.id,
                onTap: () => setState(() => _selectedMethodId = method.id),
              ).animate().fadeIn(
                    delay: Duration(milliseconds: 300 + index * 80),
                  );
            },
          ),

          const SizedBox(height: AppDimensions.lg),

          // ── Security badge ──
          _SecurityBadge().animate().fadeIn(delay: 600.ms),
        ],
      ),
    );
  }

  Widget _buildPayButton(BuildContext context, PaymentState state) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F1E),
        border: Border(
          top: BorderSide(color: Color(0xFF1A1A2E), width: 1),
        ),
      ),
      child: _GradientButton(
        label: 'Pay ₹${widget.amount.toStringAsFixed(0)}',
        onPressed: _onPayTapped,
        icon: Icons.lock_rounded,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Amount Card
// ─────────────────────────────────────────────────────────────────────────────

class _AmountCard extends StatelessWidget {
  final String orderNumber;
  final double amount;
  final AnimationController pulseController;

  const _AmountCard({
    required this.orderNumber,
    required this.amount,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4776E6).withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Lock icon with glow
          AnimatedBuilder(
            animation: pulseController,
            builder: (_, __) => Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF16213E),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4776E6)
                        .withValues(alpha: 0.2 + pulseController.value * 0.3),
                    blurRadius: 16 + pulseController.value * 12,
                    spreadRadius: 2 + pulseController.value * 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.shield_rounded,
                size: 28,
                color: Color(0xFF4776E6),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Amount
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Amount to Pay',
            style: TextStyle(
              color: Color(0xFF9B9BB5),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Divider
          const Divider(color: Color(0xFF16213E), height: 1),
          const SizedBox(height: 12),

          // Order reference
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.receipt_long_rounded,
                size: 14,
                color: Color(0xFF9B9BB5),
              ),
              const SizedBox(width: 6),
              Text(
                'Order  $orderNumber',
                style: const TextStyle(
                  color: Color(0xFF9B9BB5),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Payment Method Card
// ─────────────────────────────────────────────────────────────────────────────

class _PaymentMethodCard extends StatelessWidget {
  final _PaymentMethodOption method;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isSelected ? const Color(0xFF1A1A2E) : const Color(0xFF14142B),
          border: Border.all(
            color: isSelected ? method.color : const Color(0xFF1A1A2E),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: method.color.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: method.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(method.icon, size: 18, color: method.color),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? method.color : Colors.transparent,
                    border: Border.all(
                      color:
                          isSelected ? method.color : const Color(0xFF3A3A5E),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 10, color: Colors.white)
                      : null,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFFBBBBCC),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  method.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF9B9BB5),
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Security Badge
// ─────────────────────────────────────────────────────────────────────────────

class _SecurityBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A1A2E)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user_rounded,
              size: 16, color: Color(0xFF4CAF50)),
          const SizedBox(width: 8),
          const Flexible(
            child: Text(
              '256-bit SSL encrypted  •  Powered by Razorpay',
              style: TextStyle(
                color: Color(0xFF9B9BB5),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Gradient Pay Button
// ─────────────────────────────────────────────────────────────────────────────

class _GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const _GradientButton({
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _scaleController.forward(),
        onTapUp: (_) {
          _scaleController.reverse();
          widget.onPressed();
        },
        onTapCancel: () => _scaleController.reverse(),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4776E6).withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
