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
  static String productVariantCreate(String slug) =>
      '/products/$slug/variants/create/';
  static const categories = '/categories/';
  static const categoryTree = '/categories/tree/';
  static String categoryDetail(String slug) => '/categories/$slug/';
  static const brands = '/brands/';

  // Search
  static const search = '/search/';
  static const searchSuggestions = '/search/suggestions/';
  static const searchTrending = '/search/trending/';

  // Cart
  static const cart = '/cart/';
  static const cartAdd = '/cart/add/';
  static String cartItem(String id) => '/cart/items/$id/'; // PATCH (update)
  static String cartItemDelete(String id) =>
      '/cart/items/$id/delete/'; // DELETE (remove)
  static const cartClear = '/cart/clear/';
  static const applyCoupon = '/cart/apply-coupon/';
  static const removeCoupon = '/cart/remove-coupon/';

  // Coupons (public)
  static const availableCoupons = '/coupons/available/';

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

  // Admin
  static const adminDashboardStats = '/admin/dashboard/stats/';

  // Admin Product Management
  static const createProduct = '/products/create/';
  static const categoryCreate = '/categories/create/';
  static const brandCreate = '/brands/create/';
  static String uploadProductImage(String slug) =>
      '/products/$slug/images/upload/';
  static String updateProduct(String slug) => '/products/$slug/update/';

  // Admin Coupon Management
  static const adminCoupons = '/admin/coupons/';
  static const adminCouponCreate = '/admin/coupons/create/';
  static String adminCouponUpdate(String id) => '/admin/coupons/$id/update/';
  static String adminCouponDelete(String id) => '/admin/coupons/$id/delete/';
  static String adminCouponToggle(String id) => '/admin/coupons/$id/toggle/';

  // Reviews
  static const reviewCreate = '/reviews/';
  static String reviewList(String productSlug) => '/reviews/$productSlug/';
  static String reviewSummary(String productSlug) =>
      '/reviews/$productSlug/summary/';
  static String reviewUpdate(String reviewId) => '/reviews/$reviewId/update/';
  static String reviewDelete(String reviewId) => '/reviews/$reviewId/delete/';
  static String reviewHelpful(String reviewId) => '/reviews/$reviewId/helpful/';

  // Wishlist
  static const wishlist = '/wishlist/';
  static const wishlistAdd = '/wishlist/add/';
  static String wishlistRemove(String productId) =>
      '/wishlist/remove/$productId/';

  // Notifications
  static const notifications = '/notifications/';
  static const notificationUnreadCount = '/notifications/unread-count/';
  static const notificationMarkAllRead = '/notifications/mark-all-read/';
  static String notificationMarkRead(String id) => '/notifications/$id/read/';
  static String notificationDelete(String id) => '/notifications/$id/';
}
