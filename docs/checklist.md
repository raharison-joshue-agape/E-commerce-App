# Checklist de conformité du projet

Application e-commerce **NovaShop** — projet de certification Flutter.

Statut : **VALIDÉ** (sprint 8 — finalisation).

---

## 1. Fonctionnalités obligatoires

| Fonctionnalité | Présente | Détail / Localisation |
| --- | :-: | --- |
| Catalogue de produits | ✅ | `productsProvider` + grille adaptative (`ProductListPage`) |
| Détail produit | ✅ | `productDetailProvider` + `ProductDetailPage` (galerie, specs, avis, produits liés) |
| Panier d'achat | ✅ | `cartProvider` + `CartPage` (liste, résumé, barre de paiement) |
| Ajout / suppression / quantité | ✅ | `CartNotifier.addProduct/removeProduct/increaseQuantity/decreaseQuantity/clearCart` |
| Favoris persistants | ✅ | `FavoritesNotifier` + datasource `SharedPreferences` (survit au redémarrage) |
| Filtrage des produits | ✅ | recherche, catégorie, gamme de prix, disponibilité (`ProductFiltersState`) |
| Tri des produits | ✅ | 7 options (`ProductSortOption`), appliqué dans `ProductQuery.apply` |
| Profil utilisateur mock | ✅ | `MockProfileLocalDataSource` → `profileProvider` + statistiques |

## 2. Exigences techniques

| Exigence | Présente | Détail |
| --- | :-: | --- |
| Riverpod uniquement (state) | ✅ | Aucun autre package de state management (`flutter_riverpod` seul) |
| Au moins 5 providers distincts | ✅ | **27 providers** — voir [docs/providers.md](providers.md) |
| Architecture en couches | ✅ | `datasource → repository → providers/controllers → pages/widgets` par feature |
| `AsyncValue` pour les données asynchrones | ✅ | `productsProvider`, `productDetailProvider`, `profileProvider`, `productReviewsProvider`, `relatedProductsProvider`, `filteredProductsProvider` |
| Gestion Loading / Error / Success | ✅ | Skeletons (loading), `ErrorStateWidget` (error), rendu data (success) — `AsyncValue.when` |
| Séparation logique métier / UI | ✅ | Notifiers (`CartNotifier`, `FavoritesNotifier`, `ProductFiltersNotifier`), repositories, datasources ; UI sans logique métier |

## 3. Architecture en couches — mapping

| Couche | Rôle | Exemple de fichiers |
| --- | --- | --- |
| **Data (datasource)** | Source de données brute (mock, SharedPreferences) | `mock_product_datasource.dart`, `shared_preferences_favorites_local_datasource.dart` |
| **Domain (repository)** | Contrat + implémentation du repository | `product_repository.dart` + `product_repository_impl.dart` |
| **State (providers/controllers)** | Exposition de l'état via Riverpod | `products_providers.dart`, `cart_notifier.dart`, `favorites_notifier.dart` |
| **Presentation (pages/widgets)** | UI, `ConsumerWidget`/`ConsumerStatefulWidget` | `pages/`, `widgets/` de chaque feature |
| **App / Shared** | Thème, router, services transverses, widgets partagés | `app/`, `core/`, `shared/` |

## 4. Qualité du code

| Contrôle | Statut |
| --- | --- |
| `flutter pub get` | ✅ Aucun conflit |
| `flutter analyze` | ✅ **0 erreur, 0 warning, 0 info** |
| `dart format .` | ✅ Tout le code est formaté |
| Application compile (APK debug) | ✅ `flutter build apk --debug` OK |
| Suite de tests | ✅ **100 tests, tous verts** |
| Aucun TODO / FIXME / HACK | ✅ 0 occurrence |
| Aucun code mort | ✅ (vérifié via `flutter analyze` + revue manuelle) |
| Responsive | ✅ Grilles adaptatives (2/3/4 colonnes selon la largeur) |
| Thème clair / sombre | ✅ `AppTheme.light` / `AppTheme.dark`, `ThemeMode.system` |

## 5. Tests automatisés (localisation)

| Fichier | Couvre |
| --- | --- |
| `test/features/products/products_provider_test.dart` | Providers produits (load, erreur) |
| `test/features/products/product_filters_providers_test.dart` | Recherche, catégorie, prix, disponibilité, tri |
| `test/features/products/product_list_page_test.dart` | Grille, skeleton, états erreur/vide |
| `test/features/products/product_detail_page_test.dart` | Détail, produit introuvable |
| `test/features/products/home_page_test.dart` | Accueil, catégories, produits populaires |
| `test/features/cart/cart_provider_test.dart` | `CartNotifier` (ajout, quantité, suppression, vidage) |
| `test/features/cart/cart_page_test.dart` | Écran panier, checkout |
| `test/features/cart/cart_badge_test.dart` | Badge panier |
| `test/features/favorites/*` | Notifier, datasource persistante, badge, synchronisation, page |
| `test/features/profile/*` | Provider profil, page profil, pages secondaires |
| `test/widget_test.dart` | Bootstrap de l'application |

## 6. Parcours utilisateur validé manuellement (émulateur Android)

**Accueil → Produits → Détail → Panier → Favoris → Profil** — vérifié sur émulateur Pixel 10 Pro,
voir [docs/manual_tests.md](manual_tests.md).

| Étape | Résultat |
| --- | --- |
| Lancement, Accueil (banner, catégories, produits populaires) | ✅ |
| Navigation onglets (Produits, Favoris, Panier, Profil) | ✅ |
| Filtres inline (prix, disponibilité) + compteur actif | ✅ |
| Détail produit (galerie, prix, avis, actions) | ✅ |
| Ajout au panier + badge panier | ✅ |
| Ajout favori + badge favoris | ✅ |
| Récapitulatif panier (sous-total, livraison, total, commander) | ✅ |
| Profil (en-tête, statistiques synchronisées panier/favoris) | ✅ |
| États vide / erreur | ✅ (tests widget) |
| Thème sombre | ✅ (via `ThemeMode.system`) |

## 7. Checklist finale de livraison

- [x] `flutter pub get`
- [x] `flutter analyze` → 0 issue
- [x] `dart format .`
- [x] L'application compile (APK debug)
- [x] Navigation complète fonctionnelle
- [x] Aucune exception visible pendant le parcours
- [x] README complet
- [x] Captures d'écran présentes (`screenshots/`)
- [x] Providers documentés (`docs/providers.md`)
- [x] Tests manuels documentés (`docs/manual_tests.md`)
- [x] Dépôt prêt à être rendu (`.gitignore`, `LICENSE`, `README.md`, `docs/`, `screenshots/`)
