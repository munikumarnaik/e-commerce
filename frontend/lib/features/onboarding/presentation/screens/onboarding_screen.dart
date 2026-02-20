import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../shared/providers/storage_providers.dart';

// ─────────────────────────────────────────────────────────
// Data model for each onboarding page
// ─────────────────────────────────────────────────────────
class _OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color accentColor;
  final IconData icon;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.accentColor,
    required this.icon,
  });
}

const _pages = [
  _OnboardingPage(
    emoji: '🍔',
    title: 'Delicious Food,\nDelivered Fast',
    subtitle:
        'Order from hundreds of restaurants near you. Fresh meals at your doorstep in minutes.',
    bgColor: Color(0xFFFFF7ED),
    accentColor: Color(0xFFF97316),
    icon: Icons.restaurant_rounded,
  ),
  _OnboardingPage(
    emoji: '👗',
    title: 'Fashion at\nYour Fingertips',
    subtitle:
        'Explore trending styles across all categories. Shop the latest clothing and accessories.',
    bgColor: Color(0xFFF5F3FF),
    accentColor: Color(0xFF8B5CF6),
    icon: Icons.checkroom_rounded,
  ),
  _OnboardingPage(
    emoji: '🛍️',
    title: 'One App,\nEverything You Need',
    subtitle:
        'Secure payments, real-time order tracking and exclusive deals — all in one place.',
    bgColor: Color(0xFFEFF6FF),
    accentColor: Color(0xFF3B82F6),
    icon: Icons.shopping_bag_rounded,
  ),
];

// ─────────────────────────────────────────────────────────
// Onboarding Screen
// ─────────────────────────────────────────────────────────
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skipOnboarding() => _finishOnboarding();

  Future<void> _finishOnboarding() async {
    await ref.read(localStorageProvider).setOnboardingComplete();
    if (!mounted) return;
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    final isLast = _currentPage == _pages.length - 1;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      color: page.bgColor,
      child: SafeArea(
        child: Column(
          children: [
            // ── Top bar (Skip)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page counter dots
                  Row(
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.only(right: 6),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? page.accentColor
                              : page.accentColor.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Skip button (hidden on last page)
                  AnimatedOpacity(
                    opacity: isLast ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: TextButton(
                      onPressed: isLast ? null : _skipOnboarding,
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: page.accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── PageView (takes all remaining space)
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPageView(page: _pages[index]);
                },
              ),
            ),

            // ── Bottom button area
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: page.accentColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: page.accentColor.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: _nextPage,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isLast ? 'Get Started' : 'Next',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              isLast
                                  ? Icons.rocket_launch_rounded
                                  : Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Individual Page Widget
// ─────────────────────────────────────────────────────────
class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Illustration Container
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: page.accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: page.accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                // Emoji + icon
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      page.emoji,
                      style: const TextStyle(fontSize: 72),
                    ),
                  ],
                ),
              ],
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0.7, 0.7),
                end: const Offset(1.0, 1.0),
                duration: 500.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: 400.ms),

          const SizedBox(height: 40),

          // ── Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
              height: 1.2,
            ),
          ).animate().fadeIn(delay: 150.ms, duration: 400.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 150.ms,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: 16),

          // ── Subtitle
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF64748B),
              height: 1.6,
            ),
          ).animate().fadeIn(delay: 250.ms, duration: 400.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 250.ms,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: 24),

          // ── Feature chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: page.accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: page.accentColor.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(page.icon, size: 16, color: page.accentColor),
                const SizedBox(width: 6),
                Text(
                  _chipLabel(page.icon),
                  style: TextStyle(
                    color: page.accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 350.ms, duration: 400.ms).scale(
                begin: const Offset(0.8, 0.8),
                delay: 350.ms,
                duration: 300.ms,
                curve: Curves.easeOut,
              ),
        ],
      ),
    );
  }

  String _chipLabel(IconData icon) {
    if (icon == Icons.restaurant_rounded) return 'Fast Delivery';
    if (icon == Icons.checkroom_rounded) return 'Trending Styles';
    return 'Secure Shopping';
  }
}
