import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/cached_image.dart';
import '../../domain/models/product_image_model.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<ProductImage> images;
  final String? thumbnail;
  final String heroTag;

  const ProductImageCarousel({
    super.key,
    required this.images,
    this.thumbnail,
    required this.heroTag,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _currentIndex = 0;

  List<String> get _imageUrls {
    if (widget.images.isNotEmpty) {
      return widget.images.map((e) => e.imageUrl).toList();
    }
    if (widget.thumbnail != null) {
      return [widget.thumbnail!];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final urls = _imageUrls;

    if (urls.isEmpty) {
      return Container(
        height: 360,
        color: theme.colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Hero(
          tag: widget.heroTag,
          child: CarouselSlider.builder(
            itemCount: urls.length,
            options: CarouselOptions(
              height: 360,
              viewportFraction: 1.0,
              enableInfiniteScroll: urls.length > 1,
              onPageChanged: (index, _) =>
                  setState(() => _currentIndex = index),
            ),
            itemBuilder: (context, index, _) {
              return CachedImage(
                imageUrl: urls[index],
                height: 360,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        if (urls.length > 1)
          Positioned(
            bottom: AppDimensions.md,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.sm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: AnimatedSmoothIndicator(
                activeIndex: _currentIndex,
                count: urls.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotColor: theme.colorScheme.primary,
                  dotColor: theme.colorScheme.outlineVariant,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
