import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../domain/models/address_model.dart';
import '../providers/address_provider.dart';
import 'address_form_screen.dart';

class AddressListScreen extends ConsumerWidget {
  /// When true, tapping an address returns it via pop instead of navigating.
  final bool selectionMode;

  const AddressListScreen({super.key, this.selectionMode = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addressProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectionMode ? 'Select Address' : 'My Addresses'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Address'),
      ),
      body: _buildBody(context, ref, state, theme),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AddressState state,
    ThemeData theme,
  ) {
    switch (state.status) {
      case AddressStatus.initial:
      case AddressStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case AddressStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48,
                  color: theme.colorScheme.error.withValues(alpha: 0.6)),
              const SizedBox(height: AppDimensions.md),
              Text('Failed to load addresses',
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: AppDimensions.sm),
              CustomButton(
                label: 'Retry',
                onPressed: () =>
                    ref.read(addressProvider.notifier).loadAddresses(),
                fullWidth: false,
                variant: ButtonVariant.outlined,
              ),
            ],
          ),
        );

      case AddressStatus.loaded:
        if (state.addresses.isEmpty) {
          return EmptyStateWidget(
            title: 'No addresses yet',
            subtitle: 'Add a delivery address to get started.',
            icon: Icons.location_off_rounded,
            actionLabel: 'Add Address',
            onAction: () => _openForm(context),
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              ref.read(addressProvider.notifier).loadAddresses(),
          child: ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.md),
            itemCount: state.addresses.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppDimensions.sm),
            itemBuilder: (context, index) {
              final address = state.addresses[index];
              return _AddressCard(
                address: address,
                selectionMode: selectionMode,
                onTap: selectionMode
                    ? () => context.pop(address)
                    : null,
                onEdit: () => _openForm(context, address: address),
                onDelete: () => _confirmDelete(context, ref, address),
                onSetDefault: () =>
                    ref.read(addressProvider.notifier).setDefault(address.id),
              );
            },
          ),
        );
    }
  }

  void _openForm(BuildContext context, {Address? address}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddressFormScreen(address: address),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Address address) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(addressProvider.notifier).deleteAddress(address.id);
            },
            child: Text('Delete',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final Address address;
  final bool selectionMode;
  final VoidCallback? onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.selectionMode,
    this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeIcon = switch (address.addressType) {
      'HOME' => Icons.home_rounded,
      'WORK' => Icons.work_rounded,
      _ => Icons.location_on_rounded,
    };
    final typeLabel = switch (address.addressType) {
      'HOME' => 'Home',
      'WORK' => 'Work',
      _ => 'Other',
    };

    return Card(
      elevation: address.isDefault ? 2 : 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        side: address.isDefault
            ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
            : BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(typeIcon,
                      size: 20,
                      color: theme.colorScheme.primary),
                  const SizedBox(width: AppDimensions.sm),
                  Text(
                    typeLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (address.isDefault) ...[
                    const SizedBox(width: AppDimensions.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusFull),
                      ),
                      child: Text(
                        'Default',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (!selectionMode) ...[
                    _ActionIcon(
                      icon: Icons.edit_outlined,
                      onTap: onEdit,
                      tooltip: 'Edit',
                    ),
                    const SizedBox(width: 4),
                    _ActionIcon(
                      icon: Icons.delete_outline_rounded,
                      onTap: onDelete,
                      tooltip: 'Delete',
                      color: theme.colorScheme.error,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppDimensions.sm),

              // Name & Phone
              Text(
                address.fullName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (address.phone.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  address.phone,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.xs),

              // Address lines
              Text(
                _formatAddress(address),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),

              // Set default button
              if (!address.isDefault && !selectionMode) ...[
                const SizedBox(height: AppDimensions.sm),
                InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onSetDefault();
                  },
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSm),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 2),
                    child: Text(
                      'Set as default',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatAddress(Address a) {
    final parts = <String>[
      a.addressLine1,
      if (a.addressLine2 != null && a.addressLine2!.isNotEmpty) a.addressLine2!,
      '${a.city}, ${a.state} ${a.postalCode}',
      a.country,
    ];
    return parts.join('\n');
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color? color;

  const _ActionIcon({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}
