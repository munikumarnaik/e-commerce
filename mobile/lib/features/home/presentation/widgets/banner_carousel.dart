import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/theme_provider.dart';

class BannerCarousel extends StatefulWidget {
  final AppCategory category;

  const BannerCarousel({super.key, required this.category});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;

  List<_BannerData> get _banners => widget.category == AppCategory.food
      ? const [
          _BannerData(
            title: 'Fresh Flavors',
            subtitle: 'Up to 40% off on gourmet meals',
            gradient: [Color(0xFFFF6B35), Color(0xFFFF9F1C)],
            icon: Icons.fastfood_rounded,
          ),
          _BannerData(
            title: 'Healthy Bites',
            subtitle: 'Organic & Vegan options available',
            gradient: [Color(0xFF2EC4B6), Color(0xFF20A4F3)],
            icon: Icons.eco_rounded,
          ),
          _BannerData(
            title: 'Quick Delivery',
            subtitle: 'Get your food in under 30 mins',
            gradient: [Color(0xFFE94560), Color(0xFFFF6B6B)],
            icon: Icons.delivery_dining_rounded,
          ),
        ]
      : const [
          _BannerData(
            title: 'New Arrivals',
            subtitle: 'Trending styles just dropped',
            gradient: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            icon: Icons.local_fire_department_rounded,
          ),
          _BannerData(
            title: 'Summer Sale',
            subtitle: 'Up to 60% off on select brands',
            gradient: [Color(0xFFE94560), Color(0xFFFF6B6B)],
            icon: Icons.sell_rounded,
          ),
          _BannerData(
            title: 'Premium Collection',
            subtitle: 'Curated pieces for every occasion',
            gradient: [Color(0xFF6C63FF), Color(0xFF3F3D56)],
            icon: Icons.diamond_rounded,
          ),
        ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final banners = _banners;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
            height: 160,
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, _) =>
                setState(() => _currentIndex = index),
          ),
          itemBuilder: (context, index, _) {
            final banner = banners[index];
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: banner.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
              child: Stack(
                children: [
                  // Decorative circle
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Icon(
                      banner.icon,
                      size: 120,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          banner.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          banner.subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: AppDimensions.sm),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: banners.length,
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: theme.colorScheme.primary,
            dotColor: theme.colorScheme.outlineVariant,
          ),
        ),
      ],
    );
  }
}

class _BannerData {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final IconData icon;

  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
  });
}
