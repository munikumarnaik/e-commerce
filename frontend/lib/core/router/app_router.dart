import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/payment/presentation/screens/payment_failure_screen.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';
import '../../features/payment/presentation/screens/payment_success_screen.dart';
import '../../features/auth/domain/models/auth_state.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/admin/presentation/screens/admin_coupons_screen.dart';
import '../../features/admin/presentation/screens/admin_create_product_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/address/presentation/screens/address_list_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/order/presentation/screens/order_detail_screen.dart';
import '../../features/order/presentation/screens/order_list_screen.dart';
import '../../features/order/presentation/screens/order_success_screen.dart';
import '../../features/order/presentation/screens/order_track_screen.dart';
import '../../features/reviews/presentation/screens/reviews_list_screen.dart';
import '../../features/reviews/presentation/screens/write_review_screen.dart';
import '../../features/wishlist/presentation/screens/wishlist_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/product/domain/models/product_filter.dart';
import '../../features/product/presentation/screens/category_listing_screen.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/profile/presentation/screens/profile_placeholder_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/shell/presentation/screens/main_shell.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _searchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final _cartNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'cart');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

// Notifies GoRouter when auth state changes — without recreating the router
class _AuthRouterNotifier extends ChangeNotifier {
  _AuthRouterNotifier(Ref ref) {
    ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthRouterNotifier(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final authenticated = authState is AuthAuthenticated ? authState : null;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isSplash = state.matchedLocation == RouteNames.splash;
      final isOnboarding = state.matchedLocation == RouteNames.onboarding;
      final isAdminRoute = state.matchedLocation.startsWith('/admin');

      if (isSplash || isOnboarding) return null;
      if (authenticated == null && !isAuthRoute) return RouteNames.login;
      if (authenticated != null && isAuthRoute) {
        final role = authenticated.user.role;
        if (role == 'ADMIN' || role == 'VENDOR') return RouteNames.admin;
        return RouteNames.home;
      }
      // Prevent customers from accessing admin routes
      if (authenticated != null && isAdminRoute) {
        final role = authenticated.user.role;
        if (role != 'ADMIN' && role != 'VENDOR') return RouteNames.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Home tab
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Search tab
          StatefulShellBranch(
            navigatorKey: _searchNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          // Cart tab
          StatefulShellBranch(
            navigatorKey: _cartNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.cart,
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          // Profile tab
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: RouteNames.profile,
                builder: (context, state) => const ProfilePlaceholderScreen(),
              ),
            ],
          ),
        ],
      ),

      // Admin routes
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteNames.admin,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteNames.adminCreateProduct,
        builder: (context, state) => const AdminCreateProductScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteNames.adminCoupons,
        builder: (context, state) => const AdminCouponsScreen(),
      ),

      // Product detail (full-screen, outside shell)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/products/:slug',
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          return ProductDetailScreen(slug: slug);
        },
      ),

      // Wishlist (full-screen, outside shell)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteNames.wishlist,
        builder: (context, state) => const WishlistScreen(),
      ),

      // Filtered product listing (full-screen, outside shell)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/filtered-products',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final title = extra['title'] as String? ?? 'Products';
          final filter = extra['filter'] as ProductFilter? ?? ProductFilter();
          return FilteredProductListingScreen(
            title: title,
            filter: filter,
          );
        },
      ),

      // ── Phase 4: Address, Checkout & Orders ──

      // Addresses (full-screen, outside shell)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteNames.profileAddresses,
        builder: (context, state) => const AddressListScreen(),
      ),

      // Checkout (full-screen)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteNames.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),

      // Order success (full-screen, no back)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteNames.orderSuccess,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final orderNumber = extra['order_number'] as String? ?? '';
          return OrderSuccessScreen(orderNumber: orderNumber);
        },
      ),

      // Orders list
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteNames.orders,
        builder: (context, state) => const OrderListScreen(),
      ),

      // Order detail
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/orders/:orderNumber',
        builder: (context, state) {
          final orderNumber = state.pathParameters['orderNumber']!;
          return OrderDetailScreen(orderNumber: orderNumber);
        },
      ),

      // Order tracking
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/orders/:orderNumber/track',
        builder: (context, state) {
          final orderNumber = state.pathParameters['orderNumber']!;
          return OrderTrackScreen(orderNumber: orderNumber);
        },
      ),

      // ── Phase 7: Reviews ──

      // Reviews list for a product
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/reviews/:productSlug',
        builder: (context, state) {
          final slug = state.pathParameters['productSlug']!;
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final productName = extra['product_name'] as String? ?? '';
          return ReviewsListScreen(productSlug: slug, productName: productName);
        },
      ),

      // Write a review
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/reviews/:productSlug/write',
        builder: (context, state) {
          final slug = state.pathParameters['productSlug']!;
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final productName = extra['product_name'] as String? ?? '';
          return WriteReviewScreen(productSlug: slug, productName: productName);
        },
      ),

      // ── Phase 5: Payment ──

      // Payment screen (ONLINE payment gateway)
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteNames.payment,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final orderNumber = extra['order_number'] as String? ?? '';
          final amount = (extra['amount'] as num?)?.toDouble() ?? 0.0;
          return PaymentScreen(orderNumber: orderNumber, amount: amount);
        },
      ),

      // Payment success
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteNames.paymentSuccess,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return PaymentSuccessScreen(
            orderNumber: extra['order_number'] as String? ?? '',
            transactionId: extra['transaction_id'] as String?,
            amount: (extra['amount'] as num?)?.toDouble() ?? 0.0,
          );
        },
      ),

      // Payment failure
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RouteNames.paymentFailure,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return PaymentFailureScreen(
            orderNumber: extra['order_number'] as String? ?? '',
            errorMessage: extra['error'] as String?,
            amount: (extra['amount'] as num?)?.toDouble() ?? 0.0,
          );
        },
      ),
    ],
  );
});
