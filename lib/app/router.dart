import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_routes.dart';
import '../core/widgets/not_found_page.dart';
import '../features/cart/pages/cart_page.dart';
import '../features/favorites/pages/favorites_page.dart';
import '../features/products/models/product.dart';
import '../features/products/pages/home_page.dart';
import '../features/products/pages/product_detail_page.dart';
import '../features/products/pages/product_list_page.dart';
import '../features/profile/pages/about_page.dart';
import '../features/profile/pages/addresses_page.dart';
import '../features/profile/pages/help_page.dart';
import '../features/profile/pages/notifications_page.dart';
import '../features/profile/pages/orders_page.dart';
import '../features/profile/pages/payment_methods_page.dart';
import '../features/profile/pages/profile_page.dart';
import '../features/profile/pages/settings_page.dart';
import 'main_shell.dart';

Page<void> _buildPage(Widget child, {required String key}) {
  return CustomTransitionPage<void>(
    key: ValueKey(key),
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
    child: child,
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                pageBuilder: (context, state) =>
                    _buildPage(const HomePage(), key: AppRoutes.home),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.products,
                name: 'products',
                pageBuilder: (context, state) => _buildPage(
                  const ProductListPage(),
                  key: AppRoutes.products,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                name: 'favorites',
                pageBuilder: (context, state) =>
                    _buildPage(const FavoritesPage(), key: AppRoutes.favorites),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                name: 'cart',
                pageBuilder: (context, state) =>
                    _buildPage(const CartPage(), key: AppRoutes.cart),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: 'profile',
                pageBuilder: (context, state) =>
                    _buildPage(const ProfilePage(), key: AppRoutes.profile),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        name: 'product-detail',
        pageBuilder: (context, state) => _buildPage(
          ProductDetailPage(
            productId: state.pathParameters['id'] ?? '',
            initialProduct: state.extra as Product?,
          ),
          key: state.matchedLocation,
        ),
      ),
      GoRoute(
        path: AppRoutes.orders,
        name: 'orders',
        pageBuilder: (context, state) =>
            _buildPage(const OrdersPage(), key: AppRoutes.orders),
      ),
      GoRoute(
        path: AppRoutes.addresses,
        name: 'addresses',
        pageBuilder: (context, state) =>
            _buildPage(const AddressesPage(), key: AppRoutes.addresses),
      ),
      GoRoute(
        path: AppRoutes.paymentMethods,
        name: 'payment-methods',
        pageBuilder: (context, state) => _buildPage(
          const PaymentMethodsPage(),
          key: AppRoutes.paymentMethods,
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        pageBuilder: (context, state) =>
            _buildPage(const NotificationsPage(), key: AppRoutes.notifications),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        pageBuilder: (context, state) =>
            _buildPage(const SettingsPage(), key: AppRoutes.settings),
      ),
      GoRoute(
        path: AppRoutes.help,
        name: 'help',
        pageBuilder: (context, state) =>
            _buildPage(const HelpPage(), key: AppRoutes.help),
      ),
      GoRoute(
        path: AppRoutes.about,
        name: 'about',
        pageBuilder: (context, state) =>
            _buildPage(const AboutPage(), key: AppRoutes.about),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
});
