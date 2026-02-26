import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../admin/domain/models/product_form_state.dart';
import '../../providers/create_product_provider.dart';

class StepVariants extends ConsumerWidget {
  const StepVariants({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(createProductProvider);
    final notifier = ref.read(createProductProvider.notifier);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sizes & Variants',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Select sizes and colors. One variant is created per size–color combination.',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppDimensions.lg),

          // Existing variant cards
          ...formState.variants.asMap().entries.map((e) {
            final v = e.value;
            return Card(
              margin: const EdgeInsets.only(bottom: AppDimensions.sm),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    v.size.length > 4 ? v.size.substring(0, 4) : v.size,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  '${v.size}${v.color != null ? ' · ${v.color}' : ''}',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Stock: ${v.stockQuantity}${v.price != null ? ' · ₹${v.price!.toStringAsFixed(0)}' : ''}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  color: theme.colorScheme.error,
                  onPressed: () => notifier.removeVariant(e.key),
                ),
              ),
            );
          }),

          if (formState.variants.isNotEmpty) const SizedBox(height: AppDimensions.sm),

          // Add variant form — fully self-contained state
          _AddVariantForm(
            clothingType: formState.clothingType,
            onVariantsAdded: (variants) {
              for (final v in variants) {
                notifier.addVariant(v);
              }
            },
          ),

          // Validation hint
          if (formState.variants.isEmpty) ...[
            const SizedBox(height: AppDimensions.sm),
            Text(
              '* Please add at least one variant to continue.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Self-contained form — manages its own selection state
// ─────────────────────────────────────────────────────
class _AddVariantForm extends StatefulWidget {
  final String? clothingType;
  final void Function(List<VariantEntry> variants) onVariantsAdded;

  const _AddVariantForm({
    required this.clothingType,
    required this.onVariantsAdded,
  });

  @override
  State<_AddVariantForm> createState() => _AddVariantFormState();
}

class _AddVariantFormState extends State<_AddVariantForm> {
  final Set<String> _sizes = {};
  final Set<String> _colors = {};
  final _customColorCtrl = TextEditingController();
  final _stockCtrl = TextEditingController(text: '1');
  final _priceCtrl = TextEditingController();
  bool _expanded = false;

  static const _apparelSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
  static const _footwearSizes = [
    'UK 5', 'UK 6', 'UK 7', 'UK 8', 'UK 9', 'UK 10', 'UK 11', 'UK 12',
  ];
  static const _commonColors = [
    'Black', 'White', 'Red', 'Blue', 'Navy',
    'Green', 'Yellow', 'Pink', 'Purple', 'Brown',
    'Grey', 'Beige', 'Orange', 'Maroon',
  ];
  static const _colorHexMap = {
    'Black':  '#000000',
    'White':  '#FFFFFF',
    'Red':    '#F44336',
    'Blue':   '#2196F3',
    'Navy':   '#001F5B',
    'Green':  '#4CAF50',
    'Yellow': '#FFEB3B',
    'Pink':   '#E91E8C',
    'Purple': '#9C27B0',
    'Brown':  '#795548',
    'Grey':   '#9E9E9E',
    'Beige':  '#F5F5DC',
    'Orange': '#FF9800',
    'Maroon': '#800000',
  };

  @override
  void dispose() {
    _customColorCtrl.dispose();
    _stockCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  List<String> get _sizeOptions =>
      widget.clothingType == 'FOOTWEAR' ? _footwearSizes : _apparelSizes;

  int get _variantCount =>
      _sizes.isEmpty ? 0 : _sizes.length * (_colors.isEmpty ? 1 : _colors.length);

  void _toggleSize(String s) {
    setState(() {
      if (_sizes.contains(s)) {
        _sizes.remove(s);
      } else {
        _sizes.add(s);
      }
    });
  }

  void _toggleColor(String c) {
    setState(() {
      if (_colors.contains(c)) {
        _colors.remove(c);
      } else {
        _colors.add(c);
      }
    });
  }

  void _addCustomColor() {
    final color = _customColorCtrl.text.trim();
    if (color.isEmpty) return;
    setState(() {
      _colors.add(color);
      _customColorCtrl.clear();
    });
  }

  void _submit() {
    if (_sizes.isEmpty) return;
    final stock = int.tryParse(_stockCtrl.text.trim()) ?? 1;
    final price = double.tryParse(_priceCtrl.text.trim());
    final colorList = _colors.isEmpty ? <String?>[null] : _colors.toList().cast<String?>();

    final variants = <VariantEntry>[];
    for (final size in _sizes) {
      for (final color in colorList) {
        variants.add(VariantEntry(
          size: size,
          color: color,
          colorHex: color != null ? _colorHexMap[color] : null,
          stockQuantity: stock,
          price: price,
        ));
      }
    }

    widget.onVariantsAdded(variants);

    // Reset form
    setState(() {
      _sizes.clear();
      _colors.clear();
      _customColorCtrl.clear();
      _stockCtrl.text = '1';
      _priceCtrl.clear();
      _expanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_expanded) {
      return OutlinedButton.icon(
        onPressed: () => setState(() => _expanded = true),
        icon: const Icon(Icons.add),
        label: const Text('Add Size & Color Variants'),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Sizes ───────────────────────────────
          _label(theme, 'Select Sizes *', _sizes.isNotEmpty ? '${_sizes.length} selected' : null),
          const SizedBox(height: AppDimensions.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _sizeOptions.map((s) {
              return FilterChip(
                label: Text(s),
                selected: _sizes.contains(s),
                onSelected: (_) => _toggleSize(s),
                showCheckmark: true,
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.lg),

          // ── Colors ──────────────────────────────
          _label(theme, 'Select Colors', _colors.isNotEmpty ? '${_colors.length} selected' : null),
          Text(
            'optional — leave blank for size-only variants',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppDimensions.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._commonColors.map((c) {
                return FilterChip(
                  label: Text(c),
                  selected: _colors.contains(c),
                  onSelected: (_) => _toggleColor(c),
                  showCheckmark: true,
                );
              }),
              ..._colors.where((c) => !_commonColors.contains(c)).map((c) {
                return FilterChip(
                  label: Text(c),
                  selected: true,
                  onSelected: (_) => _toggleColor(c),
                  showCheckmark: true,
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => _toggleColor(c),
                );
              }),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),

          // Custom color input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customColorCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Add custom color',
                    hintText: 'e.g. Olive Green',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                  onSubmitted: (_) => _addCustomColor(),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              FilledButton.tonal(
                onPressed: _addCustomColor,
                style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),

          // ── Stock & Price ────────────────────────
          _label(theme, 'Stock & Price', null),
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _stockCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Stock per variant *',
                    hintText: '1',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: TextField(
                  controller: _priceCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Price override ₹',
                    hintText: 'optional',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                ),
              ),
            ],
          ),

          // Variant count preview
          if (_variantCount > 0) ...[
            const SizedBox(height: AppDimensions.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'This will create $_variantCount variant${_variantCount > 1 ? 's' : ''} '
                '(${_sizes.length} size${_sizes.length > 1 ? 's' : ''}'
                '${_colors.isNotEmpty ? ' × ${_colors.length} color${_colors.length > 1 ? 's' : ''}' : ''})',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.md),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() {
                  _sizes.clear();
                  _colors.clear();
                  _customColorCtrl.clear();
                  _stockCtrl.text = '1';
                  _priceCtrl.clear();
                  _expanded = false;
                }),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: AppDimensions.sm),
              FilledButton(
                onPressed: _sizes.isNotEmpty ? _submit : null,
                child: Text(
                  _variantCount > 1 ? 'Add $_variantCount Variants' : 'Add Variant',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(ThemeData theme, String text, String? badge) {
    return Row(
      children: [
        Text(text, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Text('($badge)', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary)),
        ],
      ],
    );
  }
}
