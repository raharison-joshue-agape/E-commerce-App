# Providers — documentation

Projet **NovaShop** (Flutter + Riverpod `flutter_riverpod: ^3.4.2`).

Ce document décrit chaque provider, son type, sa responsabilité et les données exposées.
Architecture : chaque provider est déclaré dans `lib/features/<feature>/providers/` (ou `lib/app/` pour le router).

---

## Vue d'ensemble

| Provider | Type | Rôle |
| --- | --- | --- |
| `productsProvider` | `FutureProvider<List<Product>>` | Charge le catalogue complet |
| `popularProductsProvider` | `FutureProvider<List<Product>>` | Top 6 des produits les mieux notés |
| `productDetailProvider` | `FutureProvider.family<Product, String>` | Détail d'un produit par id |
| `relatedProductsProvider` | `FutureProvider.family<List<Product>, String>` | Produits liés (même catégorie, puis note) |
| `productReviewsProvider` | `FutureProvider.family<List<ProductReview>, String>` | Avis d'un produit par id |
| `productFiltersProvider` | `NotifierProvider<ProductFiltersNotifier, ProductFiltersState>` | État des filtres + tri |
| `searchQueryProvider` | `Provider<String>` | Requête de recherche (dérivé filtré) |
| `selectedCategoryProvider` | `Provider<String?>` | Catégorie sélectionnée (dérivé filtré) |
| `priceRangeProvider` | `Provider<RangeValues>` | Gamme de prix sélectionnée (dérivé filtré) |
| `availabilityProvider` | `Provider<bool>` | Filtre « disponibles uniquement » (dérivé filtré) |
| `sortProvider` | `Provider<ProductSortOption>` | Option de tri (dérivé filtré) |
| `activeFilterCountProvider` | `Provider<int>` | Nombre de filtres actifs (badge) |
| `filteredProductsProvider` | `Provider<AsyncValue<List<Product>>>` | Catalogue filtré + trié |
| `priceBoundsProvider` | `Provider<RangeValues>` | Bornes min/max de prix du catalogue |
| `categoriesProvider` | `Provider<List<String>>` | Catégories distinctes triées |
| `cartProvider` | `NotifierProvider<CartNotifier, CartState>` | Gère le panier |
| `favoritesProvider` | `NotifierProvider<FavoritesNotifier, FavoritesState>` | Gère les favoris (persistés) |
| `profileProvider` | `FutureProvider<User>` | Charge le profil utilisateur mock |
| `appRouterProvider` | `Provider<GoRouter>` | Config GoRouter + transitions |

### Providers d'infrastructure (injection de dépendances)

| Provider | Type | Rôle |
| --- | --- | --- |
| `productDatasourceProvider` | `Provider<ProductDatasource>` | Datasource produits (mock) |
| `productRepositoryProvider` | `Provider<ProductRepository>` | Repository produits |
| `productReviewDatasourceProvider` | `Provider<ProductReviewDatasource>` | Datasource avis (mock) |
| `productReviewRepositoryProvider` | `Provider<ProductReviewRepository>` | Repository avis |
| `favoritesLocalDataSourceProvider` | `Provider<FavoritesLocalDataSource>` | Datasource favoris persistée (SharedPreferences) |
| `favoritesRepositoryProvider` | `Provider<FavoritesRepository>` | Repository favoris |
| `profileLocalDataSourceProvider` | `Provider<ProfileLocalDataSource>` | Datasource profil (mock) |
| `profileRepositoryProvider` | `Provider<ProfileRepository>` | Repository profil |

---

## Détail par provider

### Produits

**`productsProvider`** — `FutureProvider<List<Product>>`
Charge le catalogue complet depuis `ProductRepository.getProducts()` (datasource mock avec délai simulé).
Données exposées : `AsyncValue<List<Product>>` (liste complète, triée par pertinence par défaut).

**`popularProductsProvider`** — `FutureProvider<List<Product>>`
Provider dérivé de `productsProvider` : trie par note décroissante et renvoie les 6 premiers.
Données exposées : `AsyncValue<List<Product>>` (top 6 de l'accueil).

**`productDetailProvider`** — `FutureProvider.family<Product, String>`
Charge un produit par id (`getProductById`). Lève `ProductNotFoundException` si absent → page 404 stylée.
La famille évite le rechargement entre deux produits déjà consultés. `retry: null` : un échec reste un échec stable (pas de re-fetch automatique).

**`relatedProductsProvider`** — `FutureProvider.family<List<Product>, String>`
Provider dérivé de `productsProvider` : exclut le produit courant, priorise la même catégorie, puis trie par note. Renvoie 6 produits.

**`productReviewsProvider`** — `FutureProvider.family<List<ProductReview>, String>`
Charge les avis d'un produit via `ProductReviewRepository.getReviews(productId)`.

### Filtres & tri

**`productFiltersProvider`** — `NotifierProvider<ProductFiltersNotifier, ProductFiltersState>`
État mutable des filtres : `searchQuery`, `selectedCategory`, `priceRange`, `onlyAvailable`, `sort`.
Actions : `setSearchQuery`, `clearSearch`, `setCategory`, `setPriceRange`, `setOnlyAvailable`, `setSort`, `resetFilters`.

**`searchQueryProvider`** / **`selectedCategoryProvider`** / **`priceRangeProvider`** / **`availabilityProvider`** / **`sortProvider`** — `Provider` dérivés
Exposent chacun un champ du filtre via `select()` : chaque widget ne se rebuild que lorsque le champ qu'il consomme change (pas le filtre entier).

**`priceBoundsProvider`** — `Provider<RangeValues>`
Calcule les bornes min/max du prix du catalogue (utile pour le slider). Retourne `RangeValues(0, 3000)` si le catalogue est vide.

**`categoriesProvider`** — `Provider<List<String>>`
Extrait les catégories distinctes du catalogue, triées par ordre alphabétique.

**`activeFilterCountProvider`** — `Provider<int>`
Compte les filtres actifs (recherche, catégorie, prix ≠ bornes, disponibilité, tri ≠ pertinence) pour le badge « N Filtres ».

**`filteredProductsProvider`** — `Provider<AsyncValue<List<Product>>>`
Provider dérivé : applique `ProductQuery.apply(products)` (filtrage + tri) sur le catalogue.
`whenData` préserve l'état `AsyncLoading`/`AsyncError` de `productsProvider`.

### Panier

**`cartProvider`** — `NotifierProvider<CartNotifier, CartState>`
État du panier : `List<CartItem>` immuable.
Getters dérivés : `itemCount` (somme des quantités), `subtotal`, `total`, `isEmpty`.
Actions : `addProduct`, `removeProduct`, `increaseQuantity`, `decreaseQuantity` (min 1), `clearCart`.
⚠️ Le panier est **non persistant** (volatil au redémarrage, comme attendu pour le périmètre).

### Favoris

**`favoritesProvider`** — `NotifierProvider<FavoritesNotifier, FavoritesState>`
État des favoris : `Set<String>` d'ids + `isLoading`/`error`.
Optimiste : l'UI est mise à jour immédiatement, puis persistée via `FavoritesRepository` ; en cas d'échec, rollback de l'état.
Persistance **SharedPreferences** : les favoris survivent au redémarrage.
Actions : `initialize`, `addFavorite`, `removeFavorite`, `toggleFavorite`, `clearFavorites`.

### Profil

**`profileProvider`** — `FutureProvider<User>`
Charge le profil mock (`MockProfileLocalDataSource`) via `ProfileRepository.getProfile()`.
Données exposées : `AsyncValue<User>` (nom, email, rang, date d'inscription, statistiques).

### Application

**`appRouterProvider`** — `Provider<GoRouter>`
Construit le `GoRouter` : `StatefulShellRoute.indexedStack` (5 onglets), routes des pages secondaires du profil, transitions Fade + Slide, page 404.

---

## Règles d'optimisation appliquées

| Règle | Application |
| --- | --- |
| `ref.watch` uniquement dans les build / providers réactifs | ✅ Toutes les pages/widgets utilisent `watch` en `build` |
| `ref.read` pour les actions (event handlers, notifiers) | ✅ `addProduct`, `toggleFavorite`, `setSearchQuery`, `clearCart`, etc. |
| Abonnements fins avec `select()` | ✅ Badges panier/favoris, champs de filtre, `FavoriteButton` |
| Pas de rebuild inutile | ✅ Les champs du filtre sont exposés séparément ; `filteredProductsProvider` ne dépend que des champs consommés |
| Providers dérivés sans duplication de travail | ✅ `popularProductsProvider`/`relatedProductsProvider` réutilisent `productsProvider` (cache Riverpod) |
| Familles pour les données paramétrées | ✅ `productDetailProvider`, `relatedProductsProvider`, `productReviewsProvider` |
