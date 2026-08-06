abstract final class AppRoutes {
  static const String home = '/';
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String favorites = '/favorites';
  static const String cart = '/cart';
  static const String profile = '/profile';

  static const String orders = '/profile/orders';
  static const String addresses = '/profile/addresses';
  static const String paymentMethods = '/profile/payment-methods';
  static const String notifications = '/profile/notifications';
  static const String settings = '/profile/settings';
  static const String help = '/profile/help';
  static const String about = '/profile/about';

  static String productDetailFor(String id) => '/products/$id';
}
