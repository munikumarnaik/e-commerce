import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/coupon_model.dart';
import '../providers/coupon_provider.dart';
import '../widgets/coupon_card.dart';
import '../widgets/coupon_form_sheet.dart';

class AdminCouponsScreen extends ConsumerWidget {
  const AdminCouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(couponProvider);
    final notifier = ref.read(couponProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Coupons'),
        centerTitle: false,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: notifier.load,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Coupon'),
      ),
      body: _buildBody(context, ref, state, notifier),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, CouponListState state,
      CouponNotifier notifier) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return _ErrorBody(message: state.error!, onRetry: notifier.load);
    }
    if (state.coupons.isEmpty) {
      return const _EmptyBody();
    }
    return RefreshIndicator(
      onRefresh: notifier.load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: state.coupons.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final coupon = state.coupons[i];
          return CouponCard(
            coupon: coupon,
            onToggle: () => notifier.toggle(coupon.id),
            onDelete: () => _confirmDelete(context, ref, coupon),
            onEdit: () => _openForm(context, ref, existing: coupon),
          );
        },
      ),
    );
  }

  void _openForm(BuildContext context, WidgetRef ref, {CouponModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => CouponFormSheet(
        existing: existing,
        onSaved: existing != null
            ? ref.read(couponProvider.notifier).updateLocally
            : ref.read(couponProvider.notifier).addLocally,
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, CouponModel coupon) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Coupon'),
        content: Text('Delete "${coupon.code}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444)),
            onPressed: () {
              Navigator.pop(context);
              ref.read(couponProvider.notifier).delete(coupon.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Empty state ─────────────────────────────────
class _EmptyBody extends StatelessWidget {
  const _EmptyBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_offer_outlined,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No coupons yet',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to create your first coupon',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

// ── Error state ─────────────────────────────────
class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
          const SizedBox(height: 12),
          Text('Failed to load coupons',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
