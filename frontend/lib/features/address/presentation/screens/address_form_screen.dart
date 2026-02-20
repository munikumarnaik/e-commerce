import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../domain/models/address_model.dart';
import '../providers/address_provider.dart';

class AddressFormScreen extends ConsumerStatefulWidget {
  final Address? address;

  const AddressFormScreen({super.key, this.address});

  @override
  ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _addressType;
  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _line1Ctrl;
  late final TextEditingController _line2Ctrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _postalCodeCtrl;
  late final TextEditingController _countryCtrl;
  late bool _isDefault;

  bool get _isEditing => widget.address != null;

  @override
  void initState() {
    super.initState();
    final a = widget.address;
    _addressType = a?.addressType ?? 'HOME';
    _fullNameCtrl = TextEditingController(text: a?.fullName ?? '');
    _phoneCtrl = TextEditingController(text: a?.phone ?? '');
    _line1Ctrl = TextEditingController(text: a?.addressLine1 ?? '');
    _line2Ctrl = TextEditingController(text: a?.addressLine2 ?? '');
    _cityCtrl = TextEditingController(text: a?.city ?? '');
    _stateCtrl = TextEditingController(text: a?.state ?? '');
    _postalCodeCtrl = TextEditingController(text: a?.postalCode ?? '');
    _countryCtrl = TextEditingController(text: a?.country ?? 'India');
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _line1Ctrl.dispose();
    _line2Ctrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _postalCodeCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      'address_type': _addressType,
      'full_name': _fullNameCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'address_line1': _line1Ctrl.text.trim(),
      'address_line2': _line2Ctrl.text.trim(),
      'city': _cityCtrl.text.trim(),
      'state': _stateCtrl.text.trim(),
      'postal_code': _postalCodeCtrl.text.trim(),
      'country': _countryCtrl.text.trim(),
      'is_default': _isDefault,
    };

    final success = await ref
        .read(addressProvider.notifier)
        .saveAddress(body, id: widget.address?.id);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              _isEditing ? 'Address updated' : 'Address added'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save address. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSaving = ref.watch(addressProvider).isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Address' : 'Add Address'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.md),
          children: [
            // Address Type
            Text('Address Type',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppDimensions.sm),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                    value: 'HOME',
                    label: Text('Home'),
                    icon: Icon(Icons.home_rounded)),
                ButtonSegment(
                    value: 'WORK',
                    label: Text('Work'),
                    icon: Icon(Icons.work_rounded)),
                ButtonSegment(
                    value: 'OTHER',
                    label: Text('Other'),
                    icon: Icon(Icons.location_on_rounded)),
              ],
              selected: {_addressType},
              onSelectionChanged: (v) =>
                  setState(() => _addressType = v.first),
            ),
            const SizedBox(height: AppDimensions.lg),

            // Full Name
            TextFormField(
              controller: _fullNameCtrl,
              decoration: const InputDecoration(
                labelText: 'Full Name *',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: AppDimensions.md),

            // Phone
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(
                labelText: 'Phone Number *',
                prefixIcon: Icon(Icons.phone_outlined),
                hintText: '+91 9876543210',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s\-]')),
              ],
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Phone is required' : null,
            ),
            const SizedBox(height: AppDimensions.md),

            // Address Line 1
            TextFormField(
              controller: _line1Ctrl,
              decoration: const InputDecoration(
                labelText: 'Address Line 1 *',
                prefixIcon: Icon(Icons.location_on_outlined),
                hintText: 'House/Flat No., Building, Street',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Address is required' : null,
            ),
            const SizedBox(height: AppDimensions.md),

            // Address Line 2
            TextFormField(
              controller: _line2Ctrl,
              decoration: const InputDecoration(
                labelText: 'Address Line 2',
                prefixIcon: Icon(Icons.location_city_outlined),
                hintText: 'Area, Landmark (optional)',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: AppDimensions.md),

            // City & State
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cityCtrl,
                    decoration: const InputDecoration(
                      labelText: 'City *',
                    ),
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z\s]')),
                    ],
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'City is required'
                        : null,
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: TextFormField(
                    controller: _stateCtrl,
                    decoration: const InputDecoration(
                      labelText: 'State *',
                    ),
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z\s]')),
                    ],
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'State is required'
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),

            // Postal Code & Country
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _postalCodeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Postal Code *',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Postal code is required'
                        : null,
                  ),
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: TextFormField(
                    controller: _countryCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),

            // Default toggle
            SwitchListTile(
              title: const Text('Set as default address'),
              subtitle: const Text(
                  'This address will be pre-selected at checkout'),
              value: _isDefault,
              onChanged: (v) => setState(() => _isDefault = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppDimensions.lg),

            // Save button
            CustomButton(
              label: _isEditing ? 'Update Address' : 'Save Address',
              onPressed: _submit,
              isLoading: isSaving,
              icon: Icons.check_rounded,
            ),
            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }
}
