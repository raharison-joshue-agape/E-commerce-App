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
import '../features/profile/pages/profile_page.dart';
import 'main_shell.dart';

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
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.products,
                name: 'products',
                builder: (context, state) => const ProductListPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                name: 'favorites',
                builder: (context, state) => const FavoritesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                name: 'cart',
                builder: (context, state) => const CartPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        name: 'product-detail',
        builder: (context, state) => ProductDetailPage(
          productId: state.pathParameters['id'] ?? '',
          initialProduct: state.extra as Product?,
        ),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
});
