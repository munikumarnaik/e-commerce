import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../providers/order_provider.dart';

class OrderTrackScreen extends ConsumerWidget {
  final String orderNumber;

  const OrderTrackScreen({super.key, required this.orderNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackAsync = ref.watch(orderTrackProvider(orderNumber));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D1A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D0D1A),
          foregroundColor: Colors.white,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Track Order',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '#$orderNumber',
                style: const TextStyle(
                  color: Color(0xFF9B9BB5),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 20),
              tooltip: 'Copy order number',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: orderNumber));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order number copied'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
        body: trackAsync.when(
          data: (data) => _TrackingContent(data: data, orderNumber: orderNumber),
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF4776E6)),
          ),
          error: (e, _) => _ErrorView(
            message: e.toString(),
            onRetry: () => ref.invalidate(orderTrackProvider(orderNumber)),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main Content
// ─────────────────────────────────────────────────────────────────────────────

class _TrackingContent extends StatelessWidget {
  final Map<String, dynamic> data;
  final String orderNumber;

  const _TrackingContent({required this.data, required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    final currentStatus = data['status'] as String? ?? 'PENDING';
    final trackingNumber = data['tracking_number'] as String?;
    final estimatedDelivery = data['estimated_delivery'] as String?;
    final timeline = (data['timeline'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.lg,
        vertical: AppDimensions.md,
      ),
      children: [
        // ── Status Hero Card ──
        _StatusHeroCard(status: currentStatus)
            .animate()
            .fadeIn(duration: 500.ms)
            .slideY(begin: -0.15, end: 0),

        const SizedBox(height: AppDimensions.lg),

        // ── Tracking info ──
        if (trackingNumber != null && trackingNumber.isNotEmpty) ...[
          _InfoCard(
            icon: Icons.local_shipping_rounded,
            iconColor: const Color(0xFF4776E6),
            label: 'Tracking Number',
            value: trackingNumber,
            isMonospace: true,
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: AppDimensions.sm),
        ],

        if (estimatedDelivery != null && estimatedDelivery.isNotEmpty) ...[
          _InfoCard(
            icon: Icons.calendar_today_rounded,
            iconColor: const Color(0xFF4CAF50),
            label: 'Estimated Delivery',
            value: _formatEstimatedDate(estimatedDelivery),
          ).animate().fadeIn(delay: 150.ms).slideX(begin: -0.1, end: 0),
          const SizedBox(height: AppDimensions.lg),
        ],

        // ── Timeline heading ──
        const Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.md),
          child: Text(
            'Order Journey',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ).animate().fadeIn(delay: 200.ms),

        // ── Progress steps ──
        _OrderProgressSteps(currentStatus: currentStatus)
            .animate()
            .fadeIn(delay: 250.ms),

        const SizedBox(height: AppDimensions.lg),

        // ── Activity timeline ──
        if (timeline.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.md),
            child: Text(
              'Activity Log',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ).animate().fadeIn(delay: 300.ms),
          _ActivityTimeline(timeline: timeline)
              .animate()
              .fadeIn(delay: 350.ms),
        ],

        const SizedBox(height: AppDimensions.xl),

        // ── Action: View Full Order ──
        _PrimaryButton(
          label: 'View Order Details',
          icon: Icons.receipt_long_rounded,
          onPressed: () => context.push('/orders/$orderNumber'),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

        const SizedBox(height: AppDimensions.xl),
      ],
    );
  }

  String _formatEstimatedDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('EEEE, dd MMMM yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status Hero Card
// ─────────────────────────────────────────────────────────────────────────────

class _StatusHeroCard extends StatelessWidget {
  final String status;

  const _StatusHeroCard({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(status);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            config.color.withValues(alpha: 0.25),
            config.color.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: config.color.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: config.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(config.icon, color: config.color, size: 28),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.label,
                  style: TextStyle(
                    color: config.color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  config.description,
                  style: const TextStyle(
                    color: Color(0xFF9B9BB5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _statusConfig(String status) {
    return switch (status) {
      'PENDING' => _StatusConfig(
          icon: Icons.access_time_rounded,
          color: Colors.orange,
          label: 'Order Placed',
          description: 'Waiting for confirmation',
        ),
      'CONFIRMED' => _StatusConfig(
          icon: Icons.check_circle_rounded,
          color: Colors.blue,
          label: 'Order Confirmed',
          description: 'Your order has been confirmed',
        ),
      'PROCESSING' => _StatusConfig(
          icon: Icons.inventory_2_rounded,
          color: Colors.indigo,
          label: 'Processing',
          description: 'Your order is being prepared',
        ),
      'SHIPPED' => _StatusConfig(
          icon: Icons.local_shipping_rounded,
          color: Colors.purple,
          label: 'Shipped',
          description: 'Your order is on its way',
        ),
      'OUT_FOR_DELIVERY' => _StatusConfig(
          icon: Icons.delivery_dining_rounded,
          color: Colors.teal,
          label: 'Out for Delivery',
          description: 'Arriving today!',
        ),
      'DELIVERED' => _StatusConfig(
          icon: Icons.check_circle_rounded,
          color: const Color(0xFF4CAF50),
          label: 'Delivered',
          description: 'Your order has been delivered',
        ),
      'CANCELLED' => _StatusConfig(
          icon: Icons.cancel_rounded,
          color: Colors.red,
          label: 'Cancelled',
          description: 'This order was cancelled',
        ),
      _ => _StatusConfig(
          icon: Icons.info_rounded,
          color: Colors.grey,
          label: status,
          description: '',
        ),
    };
  }
}

class _StatusConfig {
  final IconData icon;
  final Color color;
  final String label;
  final String description;

  const _StatusConfig({
    required this.icon,
    required this.color,
    required this.label,
    required this.description,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Order Progress Steps
// ─────────────────────────────────────────────────────────────────────────────

class _OrderProgressSteps extends StatelessWidget {
  final String currentStatus;

  const _OrderProgressSteps({required this.currentStatus});

  static const _steps = [
    _Step('PENDING', 'Placed', Icons.shopping_bag_rounded),
    _Step('CONFIRMED', 'Confirmed', Icons.check_circle_rounded),
    _Step('PROCESSING', 'Processing', Icons.inventory_2_rounded),
    _Step('SHIPPED', 'Shipped', Icons.local_shipping_rounded),
    _Step('OUT_FOR_DELIVERY', 'Out for\nDelivery', Icons.delivery_dining_rounded),
    _Step('DELIVERED', 'Delivered', Icons.home_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    if (currentStatus == 'CANCELLED') {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.cancel_rounded, color: Colors.red, size: 20),
            const SizedBox(width: AppDimensions.sm),
            Text(
              'This order has been cancelled.',
              style: TextStyle(color: Colors.red.shade300, fontSize: 14),
            ),
          ],
        ),
      );
    }

    final currentIndex = _steps.indexWhere((s) => s.status == currentStatus);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.md,
        horizontal: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A1A2E)),
      ),
      child: Row(
        children: List.generate(_steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector line
            final stepIndex = index ~/ 2;
            final isCompleted = stepIndex < currentIndex;
            return Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: isCompleted
                      ? const LinearGradient(
                          colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
                        )
                      : null,
                  color: isCompleted ? null : const Color(0xFF2A2A3E),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final step = _steps[stepIndex];
          final isCompleted = stepIndex <= currentIndex;
          final isCurrent = stepIndex == currentIndex;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutBack,
                width: isCurrent ? 38 : 32,
                height: isCurrent ? 38 : 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isCompleted
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
                        )
                      : null,
                  color: isCompleted ? null : const Color(0xFF2A2A3E),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: const Color(0xFF4776E6).withValues(alpha: 0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  step.icon,
                  size: isCurrent ? 18 : 15,
                  color: isCompleted ? Colors.white : const Color(0xFF4A4A6A),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 50,
                child: Text(
                  step.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isCompleted
                        ? (isCurrent ? Colors.white : const Color(0xFF9B9BB5))
                        : const Color(0xFF4A4A6A),
                    fontSize: 9,
                    fontWeight:
                        isCurrent ? FontWeight.w700 : FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _Step {
  final String status;
  final String label;
  final IconData icon;

  const _Step(this.status, this.label, this.icon);
}

// ─────────────────────────────────────────────────────────────────────────────
// Activity Timeline
// ─────────────────────────────────────────────────────────────────────────────

class _ActivityTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> timeline;

  const _ActivityTimeline({required this.timeline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1A1A2E)),
      ),
      child: Column(
        children: List.generate(timeline.length, (index) {
          final entry = timeline[timeline.length - 1 - index]; // newest first
          final status = entry['status'] as String? ?? '';
          final note = entry['note'] as String?;
          final createdAt = entry['created_at'] as String?;
          final isFirst = index == 0;
          final isLast = index == timeline.length - 1;

          return _TimelineEntry(
            status: status,
            note: note,
            createdAt: createdAt,
            isFirst: isFirst,
            isLast: isLast,
          ).animate().fadeIn(delay: Duration(milliseconds: 50 * index));
        }),
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  final String status;
  final String? note;
  final String? createdAt;
  final bool isFirst;
  final bool isLast;

  const _TimelineEntry({
    required this.status,
    required this.note,
    required this.createdAt,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final label = _statusLabel(status);
    final dateStr = _formatDate(createdAt);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Timeline indicator ──
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFirst ? color : color.withValues(alpha: 0.4),
                    boxShadow: isFirst
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      color: const Color(0xFF2A2A3E),
                    ),
                  ),
              ],
            ),
          ),

          // ── Content ──
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: AppDimensions.sm,
                bottom: isLast ? 0 : AppDimensions.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isFirst ? Colors.white : const Color(0xFF9B9BB5),
                      fontSize: 14,
                      fontWeight:
                          isFirst ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  if (note != null && note!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      note!,
                      style: const TextStyle(
                        color: Color(0xFF6B6B8A),
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (dateStr.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        color: Color(0xFF6B6B8A),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'PENDING' => Colors.orange,
      'CONFIRMED' => Colors.blue,
      'PROCESSING' => Colors.indigo,
      'SHIPPED' => Colors.purple,
      'OUT_FOR_DELIVERY' => Colors.teal,
      'DELIVERED' => const Color(0xFF4CAF50),
      'CANCELLED' => Colors.red,
      _ => Colors.grey,
    };
  }

  String _statusLabel(String status) {
    return switch (status) {
      'PENDING' => 'Order Placed',
      'CONFIRMED' => 'Order Confirmed',
      'PROCESSING' => 'Processing Started',
      'SHIPPED' => 'Shipped',
      'OUT_FOR_DELIVERY' => 'Out for Delivery',
      'DELIVERED' => 'Delivered',
      'CANCELLED' => 'Cancelled',
      _ => status,
    };
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return dateStr;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info Card
// ─────────────────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool isMonospace;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.isMonospace = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF14142B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A1A2E)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF9B9BB5),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: isMonospace ? 'monospace' : null,
                    letterSpacing: isMonospace ? 0.5 : 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Primary Button
// ─────────────────────────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Error View
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 52, color: Color(0xFF6B6B8A)),
            const SizedBox(height: AppDimensions.md),
            const Text(
              'Failed to load tracking info',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF9B9BB5), fontSize: 13),
            ),
            const SizedBox(height: AppDimensions.lg),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4776E6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
