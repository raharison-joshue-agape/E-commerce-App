import 'package:e_commerce_app/core/constants/app_routes.dart';
import 'package:e_commerce_app/features/cart/providers/cart_providers.dart';
import 'package:e_commerce_app/features/products/models/product.dart';
import 'package:e_commerce_app/features/profile/datasource/profile_local_datasource.dart';
import 'package:e_commerce_app/features/profile/models/user.dart';
import 'package:e_commerce_app/features/profile/pages/about_page.dart';
import 'package:e_commerce_app/features/profile/pages/orders_page.dart';
import 'package:e_commerce_app/features/profile/pages/profile_page.dart';
import 'package:e_commerce_app/features/profile/providers/profile_providers.dart';
import 'package:e_commerce_app/features/profile/widgets/profile_statistics.dart';
import 'package:e_commerce_app/shared/widgets/app_skeletons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<ProviderContainer> pumpProfile(WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ProfilePage()),
      ),
    );
    await tester.pump();
    return container;
  }

  testWidgets('shows a loader then the full profile', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpProfile(tester);

    expect(find.byType(ProfileSkeleton), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileSkeleton), findsNothing);
    expect(find.text('Camille Laurent'), findsNWidgets(2));
    expect(find.text('camille.laurent@example.com'), findsOneWidget);
    expect(find.text('Gold'), findsOneWidget);
    expect(find.textContaining('Membre depuis mars 2023'), findsOneWidget);
    expect(find.text('Statistiques'), findsOneWidget);
    expect(find.text('Informations personnelles'), findsOneWidget);
    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('+33 6 12 34 56 78'), findsOneWidget);
    expect(find.text('Lyon'), findsOneWidget);
    expect(find.text('69002'), findsOneWidget);
    expect(find.text('France'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the edit button shows a coming soon snackbar', (tester) async {
    await pumpProfile(tester);
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.text('Modifier le profil'));
    await tester.pump();

    expect(find.text('Fonctionnalité bientôt disponible'), findsOneWidget);
  });

  testWidgets('logout shows a coming soon snackbar', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpProfile(tester);
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.text('Déconnexion'));
    await tester.pump();

    expect(find.text('Fonctionnalité bientôt disponible'), findsOneWidget);
  });

  testWidgets('statistics reflect the favorites and the cart', (tester) async {
    SharedPreferences.setMockInitialValues({
      'favorite_products': ['iphone-15-pro', 'airpods-pro-2'],
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(cartProvider.notifier)
        .addProduct(
          const _TestProduct(id: 'p1', name: 'Produit 1', price: 1299),
        );
    container
        .read(cartProvider.notifier)
        .addProduct(
          const _TestProduct(id: 'p2', name: 'Produit 2', price: 199),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ProfilePage()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileStatistics), findsOneWidget);
    expect(find.text('2'), findsNWidgets(2));
    expect(find.text('1 498,00 €'), findsOneWidget);
    expect(find.text('3 487,50 €'), findsOneWidget);
  });

  testWidgets('shows an error view when loading fails and retry recovers', (
    tester,
  ) async {
    final datasource = _FlakyProfileLocalDataSource();
    final container = ProviderContainer(
      overrides: [profileLocalDataSourceProvider.overrideWithValue(datasource)],
      retry: (retryCount, error) => null,
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: ProfilePage()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Impossible de charger votre profil.'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);

    await tester.tap(find.text('Réessayer'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    expect(find.text('Camille Laurent'), findsWidgets);
    expect(find.byType(ProfileStatistics), findsOneWidget);
  });

  testWidgets('the menu navigates to the placeholder pages', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: AppRoutes.profile,
      routes: [
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: AppRoutes.orders,
          builder: (context, state) => const OrdersPage(),
        ),
        GoRoute(
          path: AppRoutes.about,
          builder: (context, state) => const AboutPage(),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    await tester.tap(find.text('Mes commandes'));
    await tester.pumpAndSettle();

    expect(find.byType(OrdersPage), findsOneWidget);
    expect(find.textContaining('historique et le suivi'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('À propos'));
    await tester.pumpAndSettle();

    expect(find.byType(AboutPage), findsOneWidget);
  });

  testWidgets('the profile page is responsive on narrow screens', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpProfile(tester);
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Camille Laurent'), findsWidgets);
    expect(find.byType(ProfileStatistics), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FlakyProfileLocalDataSource implements ProfileLocalDataSource {
  int _callCount = 0;

  @override
  Future<User> getProfile() async {
    _callCount++;
    if (_callCount == 1) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      throw Exception('Cannot load profile');
    }
    return User(
      id: 'user-1',
      firstName: 'Camille',
      lastName: 'Laurent',
      email: 'camille.laurent@example.com',
      phone: '+33 6 12 34 56 78',
      avatarUrl: 'https://example.com/avatar.png',
      address: '12 rue des Fleurs',
      city: 'Lyon',
      country: 'France',
      postalCode: '69002',
      memberSince: DateTime(2023, 3, 15),
      loyaltyLevel: 'Gold',
      totalOrders: 24,
      totalSpent: 3487.5,
    );
  }
}

class _TestProduct extends Product {
  const _TestProduct({
    required super.id,
    required super.name,
    required super.price,
  }) : super(
         description: '',
         shortDescription: '',
         imageUrl: '',
         category: 'Test',
         brand: 'Test',
         oldPrice: null,
         discount: null,
         rating: 4.5,
         reviewCount: 1,
         stock: 10,
         isAvailable: true,
         colors: const [],
         sizes: const [],
         images: const [],
         specifications: const {},
       );
}
