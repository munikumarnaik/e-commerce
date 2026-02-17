class RouteNames {
  RouteNames._();

  static const splash = '/splash';
  static const onboarding = '/onboarding';

  // Auth
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const forgotPassword = '/auth/forgot-password';
  static const verifyOtp = '/auth/verify-otp';
  static const resetPassword = '/auth/reset-password';

  // Main shell
  static const home = '/home';
  static const search = '/search';
  static const cart = '/cart';
  static const profile = '/profile';

  // Products
  static const foodDetail = '/food/:id';
  static const clothingDetail = '/clothing/:id';
  static const categoryListing = '/category/:slug';

  // Orders
  static const orders = '/orders';
  static const orderDetail = '/orders/:id';
  static const orderTrack = '/orders/:id/track';

  // Checkout
  static const checkout = '/checkout';
  static const checkoutAddress = '/checkout/address';
  static const checkoutSummary = '/checkout/summary';

  // Payment
  static const payment = '/payment';
  static const paymentSuccess = '/payment/success/:orderId';
  static const paymentFailure = '/payment/failure';

  // Admin
  static const admin = '/admin';
  static const adminCreateProduct = '/admin/create-product';

  // Others
  static const wishlist = '/wishlist';
  static const notifications = '/notifications';
  static const profileAddresses = '/profile/addresses';
  static const profileSettings = '/profile/settings';
}
