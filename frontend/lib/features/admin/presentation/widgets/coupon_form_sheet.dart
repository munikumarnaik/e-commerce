import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/repositories/admin_product_repository.dart';
import '../../domain/models/coupon_model.dart';

class CouponFormSheet extends ConsumerStatefulWidget {
  final CouponModel? existing;
  final void Function(CouponModel) onSaved;

  const CouponFormSheet({super.key, this.existing, required this.onSaved});

  @override
  ConsumerState<CouponFormSheet> createState() => _CouponFormSheetState();
}

class _CouponFormSheetState extends ConsumerState<CouponFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _codeCtrl;
  late final TextEditingController _valueCtrl;
  late final TextEditingController _maxDiscountCtrl;
  late final TextEditingController _minOrderCtrl;
  late final TextEditingController _maxUsageCtrl;
  late final TextEditingController _usagePerUserCtrl;
  late final TextEditingController _validFromCtrl;
  late final TextEditingController _validUntilCtrl;

  String _discountType = 'PERCENTAGE';
  bool _isActive = true;
  bool _isLoading = false;
  String? _error;
  DateTime? _validFrom;
  DateTime? _validUntil;

  // Product selection
  List<CouponProduct> _selectedProducts = [];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _codeCtrl = TextEditingController(text: e?.code ?? '');
    _valueCtrl =
        TextEditingController(text: e?.discountValue.toStringAsFixed(0) ?? '');
    _maxDiscountCtrl = TextEditingController(
        text: e?.maxDiscount?.toStringAsFixed(0) ?? '');
    _minOrderCtrl = TextEditingController(
        text: e?.minOrderValue.toStringAsFixed(0) ?? '0');
    _maxUsageCtrl =
        TextEditingController(text: e?.maxUsage?.toString() ?? '');
    _usagePerUserCtrl =
        TextEditingController(text: e?.usagePerUser.toString() ?? '1');
    _discountType = e?.discountType ?? 'PERCENTAGE';
    _isActive = e?.isActive ?? true;
    _selectedProducts = List.from(e?.applicableProducts ?? []);

    if (e != null) {
      _validFrom = DateTime.tryParse(e.validFrom);
      _validUntil = DateTime.tryParse(e.validUntil);
    }
    _validFromCtrl = TextEditingController(
        text: _validFrom != null ? _fmtDate(_validFrom!) : '');
    _validUntilCtrl = TextEditingController(
        text: _validUntil != null ? _fmtDate(_validUntil!) : '');
  }

  @override
  void dispose() {
    for (final c in [
      _codeCtrl, _valueCtrl, _maxDiscountCtrl, _minOrderCtrl,
      _maxUsageCtrl, _usagePerUserCtrl, _validFromCtrl, _validUntilCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String _fmtDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _validFrom : _validUntil) ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _validFrom = DateTime(picked.year, picked.month, picked.day);
        _validFromCtrl.text = _fmtDate(picked);
      } else {
        _validUntil =
            DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
        _validUntilCtrl.text = _fmtDate(picked);
      }
    });
  }

  Future<void> _openProductPicker() async {
    final result = await showModalBottomSheet<List<CouponProduct>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _ProductPickerSheet(
        dio: ref.read(dioProvider),
        alreadySelected: _selectedProducts,
      ),
    );
    if (result != null) {
      setState(() => _selectedProducts = result);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_validFrom == null || _validUntil == null) {
      setState(() => _error = 'Please select a valid date range.');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final data = {
      'code': _codeCtrl.text.trim().toUpperCase(),
      'discount_type': _discountType,
      'discount_value': double.parse(_valueCtrl.text.trim()),
      if (_maxDiscountCtrl.text.trim().isNotEmpty)
        'max_discount': double.parse(_maxDiscountCtrl.text.trim()),
      'min_order_value': double.parse(_minOrderCtrl.text.trim()),
      if (_maxUsageCtrl.text.trim().isNotEmpty)
        'max_usage': int.parse(_maxUsageCtrl.text.trim()),
      'usage_per_user': int.parse(_usagePerUserCtrl.text.trim()),
      'valid_from': _validFrom!.toUtc().toIso8601String(),
      'valid_until': _validUntil!.toUtc().toIso8601String(),
      'is_active': _isActive,
      'product_ids': _selectedProducts.map((p) => p.id).toList(),
    };

    try {
      final repo = ref.read(adminProductRepositoryProvider);
      final result = widget.existing != null
          ? await repo.updateCoupon(widget.existing!.id, data)
          : await repo.createCoupon(data);
      if (mounted) {
        Navigator.pop(context);
        widget.onSaved(CouponModel.fromJson(result));
      }
    } catch (_) {
      setState(() {
        _isLoading = false;
        _error = 'Failed. Please check the fields and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.existing != null;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEdit ? 'Edit Coupon' : 'Create Coupon',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Code field
              TextFormField(
                controller: _codeCtrl,
                enabled: !isEdit,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9\-_]')),
                  _UpperCaseFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Coupon Code *',
                  hintText: 'e.g. SAVE20',
                  prefixIcon: Icon(Icons.local_offer_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Code is required' : null,
              ),
              const SizedBox(height: 12),

              // Discount type
              Text('Discount Type *',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'PERCENTAGE',
                    label: Text('Percentage'),
                    icon: Icon(Icons.percent),
                  ),
                  ButtonSegment(
                    value: 'FIXED',
                    label: Text('Fixed ₹'),
                    icon: Icon(Icons.currency_rupee),
                  ),
                ],
                selected: {_discountType},
                onSelectionChanged: (v) =>
                    setState(() => _discountType = v.first),
              ),
              const SizedBox(height: 12),

              // Value + Max discount
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _valueCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    decoration: InputDecoration(
                      labelText: _discountType == 'PERCENTAGE'
                          ? 'Discount % *'
                          : 'Discount ₹ *',
                      prefixIcon: Icon(_discountType == 'PERCENTAGE'
                          ? Icons.percent
                          : Icons.currency_rupee),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                if (_discountType == 'PERCENTAGE') ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _maxDiscountCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Max Discount ₹',
                        prefixIcon: Icon(Icons.money_off_outlined),
                      ),
                    ),
                  ),
                ],
              ]),
              const SizedBox(height: 12),

              // Min order + Max usage
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _minOrderCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Min Order ₹',
                      prefixIcon: Icon(Icons.shopping_cart_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _maxUsageCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Max Total Uses',
                      hintText: 'Blank = unlimited',
                      prefixIcon: Icon(Icons.people_outline),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 12),

              // Uses per user
              TextFormField(
                controller: _usagePerUserCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Max Uses Per User *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Date range
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _validFromCtrl,
                    readOnly: true,
                    onTap: () => _pickDate(isFrom: true),
                    decoration: const InputDecoration(
                      labelText: 'Valid From *',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _validUntilCtrl,
                    readOnly: true,
                    onTap: () => _pickDate(isFrom: false),
                    decoration: const InputDecoration(
                      labelText: 'Valid Until *',
                      prefixIcon: Icon(Icons.event_outlined),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
              ]),
              const SizedBox(height: 12),

              // ── Applicable Products ──
              Text('Applicable Products',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                'Leave empty to apply to all products',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              if (_selectedProducts.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: _selectedProducts.map((p) {
                    return Chip(
                      label: Text(p.name, style: const TextStyle(fontSize: 12)),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => setState(() =>
                          _selectedProducts.removeWhere((x) => x.id == p.id)),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _openProductPicker,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(_selectedProducts.isEmpty
                    ? 'Select Products'
                    : 'Add More Products'),
              ),
              const SizedBox(height: 8),

              // Active toggle
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active'),
                subtitle: const Text('Enable coupon for users'),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),

              if (_error != null) ...[
                const SizedBox(height: 4),
                Text(
                  _error!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error),
                ),
              ],
              const SizedBox(height: 20),

              // Submit
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white,
                          ),
                        )
                      : Text(isEdit ? 'Save Changes' : 'Create Coupon'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
          TextEditingValue old, TextEditingValue next) =>
      next.copyWith(text: next.text.toUpperCase());
}

// ── Product Picker Bottom Sheet ──────────────────────────────────────────────

class _ProductPickerSheet extends StatefulWidget {
  final Dio dio;
  final List<CouponProduct> alreadySelected;

  const _ProductPickerSheet({
    required this.dio,
    required this.alreadySelected,
  });

  @override
  State<_ProductPickerSheet> createState() => _ProductPickerSheetState();
}

class _ProductPickerSheetState extends State<_ProductPickerSheet> {
  final _searchCtrl = TextEditingController();
  List<CouponProduct> _selected = [];
  List<_SimpleProduct> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.alreadySelected);
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts([String? search]) async {
    setState(() => _loading = true);
    try {
      final params = <String, dynamic>{};
      if (search != null && search.isNotEmpty) params['search'] = search;
      final response = await widget.dio.get(
        ApiEndpoints.products,
        queryParameters: params,
      );
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>? ?? body;
      final results = data['results'] as List? ?? [];
      _products = results
          .map((e) => _SimpleProduct(
                id: e['id'] as String,
                name: e['name'] as String,
                slug: e['slug'] as String,
                thumbnail: e['thumbnail'] as String?,
                price: e['price']?.toString() ?? '0',
              ))
          .toList();
    } catch (_) {
      _products = [];
    }
    if (mounted) setState(() => _loading = false);
  }

  bool _isSelected(String id) => _selected.any((p) => p.id == id);

  void _toggle(_SimpleProduct product) {
    setState(() {
      if (_isSelected(product.id)) {
        _selected.removeWhere((p) => p.id == product.id);
      } else {
        _selected.add(CouponProduct(
          id: product.id,
          name: product.name,
          slug: product.slug,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Products',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, _selected),
                  child: Text('Done (${_selected.length})'),
                ),
              ],
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (v) => _fetchProducts(v),
            ),
          ),

          // Product list
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? Center(
                        child: Text('No products found',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            )),
                      )
                    : ListView.builder(
                        itemCount: _products.length,
                        itemBuilder: (context, i) {
                          final p = _products[i];
                          final selected = _isSelected(p.id);
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: p.thumbnail != null
                                  ? Image.network(
                                      p.thumbnail!,
                                      width: 44, height: 44,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _placeholderImage(theme),
                                    )
                                  : _placeholderImage(theme),
                            ),
                            title: Text(
                              p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),
                            ),
                            subtitle: Text('₹${p.price}',
                                style: theme.textTheme.bodySmall),
                            trailing: Checkbox(
                              value: selected,
                              onChanged: (_) => _toggle(p),
                            ),
                            onTap: () => _toggle(p),
                            dense: true,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage(ThemeData theme) {
    return Container(
      width: 44, height: 44,
      color: theme.colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.image_outlined, size: 20),
    );
  }
}

class _SimpleProduct {
  final String id;
  final String name;
  final String slug;
  final String? thumbnail;
  final String price;

  _SimpleProduct({
    required this.id,
    required this.name,
    required this.slug,
    this.thumbnail,
    required this.price,
  });
}
