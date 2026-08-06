abstract final class AppRoutes {
  static const String home = '/';
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String favorites = '/favorites';
  static const String cart = '/cart';
  static const String profile = '/profile';

  static String productDetailFor(String id) => '/products/$id';
}
