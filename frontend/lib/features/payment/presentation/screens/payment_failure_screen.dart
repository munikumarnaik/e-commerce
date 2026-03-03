import 'dart:math' show sin, pi;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/route_names.dart';

class PaymentFailureScreen extends StatefulWidget {
  final String orderNumber;
  final String? errorMessage;
  final double amount;

  const PaymentFailureScreen({
    required this.orderNumber,
    this.errorMessage,
    this.amount = 0,
    super.key,
  });

  @override
  State<PaymentFailureScreen> createState() => _PaymentFailureScreenState();
}

class _PaymentFailureScreenState extends State<PaymentFailureScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    HapticFeedback.vibrate();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final errorMsg = widget.errorMessage ?? 'Payment could not be processed.';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(RouteNames.orders);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: const Color(0xFF0F0F1E),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.lg,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 48),

                  // ── Failure icon ──
                  _FailureIcon(controller: _shakeController)
                      .animate()
                      .scale(
                        begin: const Offset(0, 0),
                        end: const Offset(1, 1),
                        duration: 500.ms,
                        curve: Curves.elasticOut,
                      ),

                  const SizedBox(height: 28),

                  // ── Heading ──
                  const Text(
                    'Payment Failed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 8),

                  // ── Error message ──
                  Text(
                    errorMsg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF9B9BB5),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms),

                  const SizedBox(height: 32),

                  // ── Order info card ──
                  _OrderInfoCard(
                    orderNumber: widget.orderNumber,
                    amount: widget.amount,
                  )
                      .animate()
                      .fadeIn(delay: 500.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 24),

                  // ── Failure reasons ──
                  _FailureReasonsList()
                      .animate()
                      .fadeIn(delay: 600.ms),

                  const Spacer(),

                  // ── Actions ──
                  // Go to Cart (cart is still intact)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4776E6)
                                .withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => context.go(RouteNames.cart),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart_rounded,
                                  size: 18, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Go to Cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 700.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () => context.go(RouteNames.home),
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(
                        color: Color(0xFF9B9BB5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 800.ms),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Failure Icon with Shake
// ─────────────────────────────────────────────────────────────────────────────

class _FailureIcon extends StatelessWidget {
  final AnimationController controller;

  const _FailureIcon({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final shake = sin(controller.value * pi * 6) *
            (1 - controller.value) *
            8;
        return Transform.translate(
          offset: Offset(shake, 0),
          child: Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFB71C1C), Color(0xFFE53935)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE53935).withValues(alpha: 0.4),
                  blurRadius: 32,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.close_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Order info card
// ─────────────────────────────────────────────────────────────────────────────

class _OrderInfoCard extends StatelessWidget {
  final String orderNumber;
  final double amount;

  const _OrderInfoCard({
    required this.orderNumber,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D1515)),
      ),
      child: Column(
        children: [
          _Row(label: 'Order Number', value: orderNumber),
          const Divider(color: Color(0xFF1A1A2E), height: 20),
          _Row(
            label: 'Amount',
            value: '₹${amount.toStringAsFixed(0)}',
            valueColor: Colors.white,
          ),
          const Divider(color: Color(0xFF1A1A2E), height: 20),
          const _Row(
            label: 'Payment Status',
            value: 'FAILED',
            valueColor: Color(0xFFE53935),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _Row({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9B9BB5),
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF4776E6),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Failure reasons list
// ─────────────────────────────────────────────────────────────────────────────

class _FailureReasonsList extends StatelessWidget {
  const _FailureReasonsList();

  @override
  Widget build(BuildContext context) {
    const reasons = [
      'Insufficient balance in the account',
      'Card limit exceeded or bank block',
      'Incorrect OTP or authentication failure',
      'Network timeout during payment',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A1A2E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Common reasons for failure:',
            style: TextStyle(
              color: Color(0xFF9B9BB5),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...reasons.map(
            (r) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle,
                      size: 6, color: Color(0xFF9B9BB5)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      r,
                      style: const TextStyle(
                        color: Color(0xFF9B9BB5),
                        fontSize: 11,
                        height: 1.4,
                      ),
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

