import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/route_names.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String orderNumber;
  final String? transactionId;
  final double amount;

  const PaymentSuccessScreen({
    required this.orderNumber,
    this.transactionId,
    this.amount = 0,
    super.key,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    // Trigger haptic
    HapticFeedback.heavyImpact();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    // Generate celebration particles
    final rng = Random();
    _particles.addAll(List.generate(24, (_) {
      return _Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble() * 0.4,
        color: _particleColors[rng.nextInt(_particleColors.length)],
        size: 6 + rng.nextDouble() * 6,
        speed: 0.3 + rng.nextDouble() * 0.6,
      );
    }));
  }

  static const _particleColors = [
    Color(0xFF4776E6),
    Color(0xFF8E54E9),
    Color(0xFF4CAF50),
    Color(0xFFFFD700),
    Color(0xFFFF6B35),
    Color(0xFF2EC4B6),
  ];

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go(RouteNames.home);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: const Color(0xFF0F0F1E),
          body: Stack(
            children: [
              // ── Celebration particles ──
              AnimatedBuilder(
                animation: _particleController,
                builder: (_, __) {
                  return CustomPaint(
                    size: Size(size.width, size.height * 0.55),
                    painter: _ParticlePainter(
                      particles: _particles,
                      progress: _particleController.value,
                    ),
                  );
                },
              ),

              // ── Main content ──
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
                  child: Column(
                    children: [
                      const SizedBox(height: 48),

                      // ── Animated success circle ──
                      _SuccessCircle()
                          .animate()
                          .scale(
                            begin: const Offset(0, 0),
                            end: const Offset(1, 1),
                            duration: 600.ms,
                            curve: Curves.elasticOut,
                          ),

                      const SizedBox(height: 28),

                      // ── Heading ──
                      const Text(
                        'Payment Successful!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 8),

                      Text(
                        '₹${widget.amount.toStringAsFixed(0)} paid successfully',
                        style: const TextStyle(
                          color: Color(0xFF9B9BB5),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 500.ms),

                      const SizedBox(height: 32),

                      // ── Transaction details card ──
                      _TransactionCard(
                        orderNumber: widget.orderNumber,
                        transactionId: widget.transactionId,
                        amount: widget.amount,
                      )
                          .animate()
                          .fadeIn(delay: 600.ms)
                          .slideY(begin: 0.2, end: 0),

                      const Spacer(),

                      // ── Actions ──
                      _ActionButton(
                        label: 'View My Order',
                        icon: Icons.receipt_long_rounded,
                        isPrimary: true,
                        onPressed: () => context.go(
                          '/orders/${widget.orderNumber}',
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 800.ms)
                          .slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: () => context.go(RouteNames.home),
                        child: const Text(
                          'Continue Shopping',
                          style: TextStyle(
                            color: Color(0xFF9B9BB5),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 900.ms),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Success Circle
// ─────────────────────────────────────────────────────────────────────────────

class _SuccessCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
            blurRadius: 32,
            spreadRadius: 8,
          ),
        ],
      ),
      child: const Icon(
        Icons.check_rounded,
        size: 56,
        color: Colors.white,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Transaction Card
// ─────────────────────────────────────────────────────────────────────────────

class _TransactionCard extends StatelessWidget {
  final String orderNumber;
  final String? transactionId;
  final double amount;

  const _TransactionCard({
    required this.orderNumber,
    required this.amount,
    this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A1A2E)),
      ),
      child: Column(
        children: [
          _DetailRow(
            label: 'Order Number',
            value: orderNumber,
            valueStyle: const TextStyle(
              color: Color(0xFF4776E6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
          if (transactionId != null && transactionId!.isNotEmpty) ...[
            const Divider(color: Color(0xFF1A1A2E), height: 20),
            _DetailRow(
              label: 'Transaction ID',
              value: transactionId!,
              valueStyle: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
          ],
          const Divider(color: Color(0xFF1A1A2E), height: 20),
          _DetailRow(
            label: 'Amount Paid',
            value: '₹${amount.toStringAsFixed(0)}',
            valueStyle: const TextStyle(
              color: Color(0xFF4CAF50),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Divider(color: Color(0xFF1A1A2E), height: 20),
          _DetailRow(
            label: 'Payment Status',
            value: 'SUCCESS',
            valueStyle: const TextStyle(
              color: Color(0xFF4CAF50),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueStyle,
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
            fontWeight: FontWeight.w500,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: valueStyle ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action Button
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 18),
          label: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4776E6),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF9B9BB5),
          side: const BorderSide(color: Color(0xFF1A1A2E)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Particle system
// ─────────────────────────────────────────────────────────────────────────────

class _Particle {
  final double x;
  final double y;
  final Color color;
  final double size;
  final double speed;

  const _Particle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  const _ParticlePainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final dy = p.y * size.height + progress * p.speed * size.height * 1.5;
      final dx = p.x * size.width +
          sin(progress * pi * 2 + p.x * 10) * 20;
      final opacity = (1.0 - progress * 0.8).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(progress * pi * 2 * p.speed);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset.zero, width: p.size, height: p.size * 0.6),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
