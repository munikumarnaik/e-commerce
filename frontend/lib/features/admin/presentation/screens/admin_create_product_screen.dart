import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/models/product_form_state.dart';
import '../providers/create_product_provider.dart';
import '../widgets/create_product_steps/step_basic_info.dart';
import '../widgets/create_product_steps/step_images.dart';
import '../widgets/create_product_steps/step_indicator.dart';
import '../widgets/create_product_steps/step_pricing.dart';
import '../widgets/create_product_steps/step_type_details.dart';
import '../widgets/create_product_steps/step_variants.dart';

class AdminCreateProductScreen extends ConsumerStatefulWidget {
  const AdminCreateProductScreen({super.key});

  @override
  ConsumerState<AdminCreateProductScreen> createState() =>
      _AdminCreateProductScreenState();
}

class _AdminCreateProductScreenState
    extends ConsumerState<AdminCreateProductScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> _stepLabels(String productType) => [
        AppStrings.basicInfo,
        AppStrings.pricing,
        AppStrings.images,
        AppStrings.typeDetails,
        if (productType == 'CLOTHING') 'Sizes & Variants',
      ];

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createProductProvider);
    final notifier = ref.read(createProductProvider.notifier);
    final theme = Theme.of(context);
    final stepLabels = _stepLabels(formState.productType);
    final isLastStep = formState.currentStep == stepLabels.length - 1;

    // Listen for status changes
    ref.listen<ProductFormState>(createProductProvider, (prev, next) {
      if (next.status == ProductFormStatus.success) {
        context.showSnackBar(AppStrings.productCreated);
        context.pop();
      } else if (next.status == ProductFormStatus.error &&
          next.errorMessage != null) {
        context.showSnackBar(next.errorMessage!, isError: true);
      }
    });

    final isSubmitting = formState.status == ProductFormStatus.submitting ||
        formState.status == ProductFormStatus.uploadingImages;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createProduct),
      ),
      body: Column(
        children: [
          // Step indicator
          StepIndicator(
            currentStep: formState.currentStep,
            labels: stepLabels,
          ),

          // Step label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            child: Text(
              '${AppStrings.step} ${formState.currentStep + 1}: ${stepLabels[formState.currentStep]}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                StepBasicInfo(),
                StepPricing(),
                StepImages(),
                StepTypeDetails(),
                StepVariants(),
              ],
            ),
          ),

          // Navigation bar
          _NavigationBar(
            currentStep: formState.currentStep,
            isLastStep: isLastStep,
            isSubmitting: isSubmitting,
            statusMessage: formState.status == ProductFormStatus.uploadingImages
                ? AppStrings.uploadingImages
                : isSubmitting
                    ? AppStrings.creatingProduct
                    : null,
            canProceed: formState.validateCurrentStep(),
            onBack: () {
              notifier.previousStep();
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            onNext: () {
              notifier.nextStep();
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            onSubmit: () => notifier.submit(),
          ),
        ],
      ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  final int currentStep;
  final bool isLastStep;
  final bool isSubmitting;
  final String? statusMessage;
  final bool canProceed;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  const _NavigationBar({
    required this.currentStep,
    required this.isLastStep,
    required this.isSubmitting,
    this.statusMessage,
    required this.canProceed,
    required this.onBack,
    required this.onNext,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: AppDimensions.md,
        right: AppDimensions.md,
        top: AppDimensions.md,
        bottom: MediaQuery.of(context).padding.bottom + AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (statusMessage != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: AppDimensions.sm),
                Text(
                  statusMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.sm),
          ],
          Row(
            children: [
              // Back button
              if (currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSubmitting ? null : onBack,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, AppDimensions.buttonHeight),
                    ),
                    child: const Text(AppStrings.back),
                  ),
                ),
              if (currentStep > 0) const SizedBox(width: AppDimensions.md),

              // Next / Submit button
              Expanded(
                child: FilledButton(
                  onPressed: isSubmitting
                      ? null
                      : isLastStep
                          ? onSubmit
                          : canProceed
                              ? onNext
                              : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, AppDimensions.buttonHeight),
                  ),
                  child: Text(
                    isLastStep ? AppStrings.submit : AppStrings.next,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
