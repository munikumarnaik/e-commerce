class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const register = '/auth/register/';
  static const login = '/auth/login/';
  static const logout = '/auth/logout/';
  static const tokenRefresh = '/auth/token/refresh/';
  static const verifyEmail = '/auth/verify-email/';
  static const passwordReset = '/auth/password/reset/';
  static const passwordResetConfirm = '/auth/password/reset/confirm/';

  // User
  static const userProfile = '/users/me/';
  static const uploadAvatar = '/users/me/upload-avatar/';
  static const fcmToken = '/users/me/fcm-token/';

  // Addresses
  static const addresses = '/addresses/';
  static String addressDetail(String id) => '/addresses/$id/';
  static String addressSetDefault(String id) => '/addresses/$id/set-default/';

  // Products
  static const products = '/products/';
  static String productDetail(String slug) => '/products/$slug/';
  static const featuredProducts = '/products/featured/';
  static String productView(String slug) => '/products/$slug/view/';
  static String productVariants(String slug) => '/products/$slug/variants/';
  static const categories = '/categories/';
  static const categoryTree = '/categories/tree/';
  static String categoryDetail(String slug) => '/categories/$slug/';
  static const brands = '/brands/';

  // Search
  static const search = '/search/';
  static const searchSuggestions = '/search/suggestions/';

  // Cart
  static const cart = '/cart/';
  static const cartAdd = '/cart/add/';
  static String cartItem(String id) => '/cart/items/$id/';
  static const cartClear = '/cart/clear/';
  static const applyCoupon = '/cart/apply-coupon/';
  static const removeCoupon = '/cart/remove-coupon/';

  // Orders
  static const orders = '/orders/';
  static const orderCreate = '/orders/create/';
  static String orderDetail(String number) => '/orders/$number/';
  static String orderCancel(String number) => '/orders/$number/cancel/';
  static String orderReorder(String number) => '/orders/$number/reorder/';
  static String orderTrack(String number) => '/orders/$number/track/';

  // Payments
  static const paymentInitiate = '/payments/initiate/';
  static const paymentVerify = '/payments/verify/';
  static String paymentStatus(String orderNumber) => '/payments/$orderNumber/';

  // Wishlist
  static const wishlist = '/wishlist/';
  static const wishlistAdd = '/wishlist/add/';
  static String wishlistRemove(String productId) => '/wishlist/remove/$productId/';
}
