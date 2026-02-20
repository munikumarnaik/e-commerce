import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'shimmer_widget.dart';

class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;

  const CachedImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _placeholder(context);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        httpHeaders: const {
          'Accept': '*/*',
        },
        placeholder: (context, url) => ShimmerWidget(
          width: width ?? double.infinity,
          height: height ?? 200,
          borderRadius: borderRadius,
        ),
        errorWidget: (context, url, error) => _errorWidget(context, url),
      ),
    );
  }

  Widget _errorWidget(BuildContext context, String url) {
    // Fallback: try loading with Image.network which handles R2/S3 URLs better
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        headers: const {'Accept': '*/*'},
        errorBuilder: (context, error, stackTrace) => _placeholder(context),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return ShimmerWidget(
            width: width ?? double.infinity,
            height: height ?? 200,
            borderRadius: borderRadius,
          );
        },
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        Icons.image_outlined,
        size: 32,
        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
      ),
    );
  }
}
