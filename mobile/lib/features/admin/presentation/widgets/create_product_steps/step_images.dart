import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../providers/create_product_provider.dart';

class StepImages extends ConsumerWidget {
  const StepImages({super.key});

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
            AppStrings.images,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            'First image will be used as the product thumbnail',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.lg),

          // Image Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppDimensions.sm,
              mainAxisSpacing: AppDimensions.sm,
            ),
            itemCount: formState.images.length + 1,
            itemBuilder: (context, index) {
              if (index == formState.images.length) {
                return _AddImageButton(
                  onTap: () => _pickImages(context, notifier),
                );
              }

              return _ImageTile(
                image: formState.images[index],
                isFirst: index == 0,
                onRemove: () => notifier.removeImage(index),
              );
            },
          ),

          if (formState.images.isEmpty) ...[
            const SizedBox(height: AppDimensions.lg),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Text(
                    AppStrings.tapToAddImages,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickImages(
    BuildContext context,
    CreateProductNotifier notifier,
  ) async {
    if (kIsWeb) {
      // On web: directly open gallery picker (no camera support on web)
      final picker = ImagePicker();
      final images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        notifier.addImages(images);
      }
    } else {
      // On mobile: show bottom sheet with gallery + camera options
      if (!context.mounted) return;
      showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final images = await picker.pickMultiImage();
                  if (images.isNotEmpty) {
                    notifier.addImages(images);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final image =
                      await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    notifier.addImages([image]);
                  }
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}

class _AddImageButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddImageButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Center(
          child: Icon(
            Icons.add_rounded,
            size: 32,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final XFile image;
  final bool isFirst;
  final VoidCallback onRemove;

  const _ImageTile({
    required this.image,
    required this.isFirst,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          // On web, XFile.path is a blob URL — use Image.network.
          // On mobile, it's a file path — use Image.file.
          child: kIsWeb
              ? Image.network(image.path, fit: BoxFit.cover)
              : Image.file(File(image.path), fit: BoxFit.cover),
        ),
        // Thumbnail badge
        if (isFirst)
          Positioned(
            left: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Text(
                'Thumb',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        // Remove button
        Positioned(
          right: 4,
          top: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                size: 14,
                color: theme.colorScheme.onError,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
