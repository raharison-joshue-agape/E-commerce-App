<div align="center">

# 🛍️ NovaShop — E-commerce App

Application e-commerce **Flutter** complète, propulsée par **Riverpod**, conforme aux exigences d'un projet de certification : catalogue, recherche, filtres, tri, panier, favoris persistants et profil utilisateur.

**Flutter • Riverpod • GoRouter • Clean Architecture • Feature-First**

</div>

---

## 📖 Description

NovaShop est une application e-commerce démonstrative qui couvre le parcours client complet :
parcourir le catalogue, filtrer et trier les produits, consulter une fiche produit détaillée (galerie,
caractéristiques, avis, produits liés), gérer un panier, ajouter des favoris **persistants** et consulter
un profil utilisateur.

Toutes les données proviennent de **datasources mock** (avec délai réseau simulé) et de la persistance locale
`SharedPreferences` — aucune API externe n'est requise pour exécuter l'application.

## ✨ Fonctionnalités

- **Catalogue de produits** : grille responsive (2/3/4 colonnes), images, notes, remises.
- **Détail produit** : galerie multi-images, prix barré + remise, stock, couleur/taille, spécifications, avis clients, produits liés.
- **Recherche** : filtrage en temps réel (nom, marque, catégorie).
- **Filtres** : catégorie, gamme de prix (slider), disponibilité — avec compteur de filtres actifs et bouton de réinitialisation.
- **Tri** : pertinence, prix ↑/↓, A–Z / Z–A, meilleures notes, meilleures remises.
- **Panier** : ajout, quantité (+/−, min 1), suppression, vidage avec confirmation, récapitulatif (sous-total, livraison, total).
- **Favoris persistants** : ajout/suppression depuis les cartes et le détail, sauvegardés en `SharedPreferences` (survivent au redémarrage).
- **Profil utilisateur** : en-tête, rang, statistiques synchronisées avec le panier et les favoris, pages secondaires.
- **Expérience** : thème **clair / sombre** (`ThemeMode.system`), transitions de navigation, skeletons de chargement, états vide/erreur unifiés, micro-interactions, responsive.

## 🏗️ Architecture

Le projet suit les principes de la **Clean Architecture** adaptés à Flutter, organisés en **Feature-First**.

### Clean Architecture (par feature)

| Couche | Rôle |
| --- | --- |
| **Datasource** | Source de données brute (mock avec délai, `SharedPreferences`) |
| **Repository** | Contrat (`abstract`) + implémentation (`*_impl.dart`) |
| **State (providers/controllers)** | Notifiers & providers Riverpod (logique métier) |
| **Presentation** | Pages & widgets (`ConsumerWidget`/`ConsumerStatefulWidget`) |

### Feature-First

Chaque fonctionnalité est isolée dans `lib/features/<feature>/` (cart, favorites, products, profile) avec ses propres
couches. Le code transversal vit dans `lib/core/` (constantes, erreurs, utils, widgets) et `lib/shared/`
(services et widgets partagés), la configuration applicative dans `lib/app/`.

### Repository Pattern

L'UI ne dépend jamais d'une datasource : elle passe par une interface repository, ce qui rend le mock
interchangeable avec une vraie API sans toucher à la présentation.

### Riverpod

Gestion d'état centralisée, typée et testable : `FutureProvider`, `NotifierProvider`, familles, providers
dérivés et abonnements fins via `select()`.

## 📁 Structure du projet

```
e_commerce_app/
├── lib/
│   ├── main.dart                     # Point d'entrée (ProviderScope)
│   ├── app/                          # Configuration applicative
│   │   ├── app.dart                  # MaterialApp.router + thèmes
│   │   ├── main_shell.dart           # Navigation par onglets (StatefulShellRoute)
│   │   ├── router.dart               # GoRouter + transitions
│   │   └── theme.dart                # AppTheme.light / AppTheme.dark
│   ├── core/                         # Code transversal
│   │   ├── constants/                # Routes de l'application
│   │   ├── errors/                   # Exceptions métier
│   │   ├── utils/                    # formatPrice, conversion couleur
│   │   └── widgets/                  # 404, placeholder
│   ├── shared/                       # Composants réutilisables
│   │   ├── services/                 # SnackBar & Dialog unifiés
│   │   └── widgets/                  # Skeletons, états vide/erreur, PressableScale
│   └── features/                     # Features (Feature-First)
│       ├── cart/                     #   controllers · models · pages · providers · widgets
│       ├── favorites/                #   controllers · datasource · pages · providers · repository · widgets
│       ├── products/                 #   datasource · models · pages · providers · repository · widgets
│       └── profile/                  #   datasource · models · pages · providers · repository · widgets
├── test/                             # Tests unitaires & widgets (100 tests)
├── docs/                             # Checklist, providers, tests manuels
├── screenshots/                      # Captures de l'application
├── pubspec.yaml
├── analysis_options.yaml
├── LICENSE
└── README.md
```

## ⚙️ Providers utilisés

| Provider | Type | Rôle |
| --- | --- | --- |
| `productsProvider` | `FutureProvider<List<Product>>` | Charge le catalogue |
| `productDetailProvider` | `FutureProvider.family<Product, String>` | Détail d'un produit |
| `relatedProductsProvider` | `FutureProvider.family<List<Product>, String>` | Produits liés |
| `productReviewsProvider` | `FutureProvider.family<List<ProductReview>, String>` | Avis clients |
| `productFiltersProvider` | `NotifierProvider<...>` | État des filtres et du tri |
| `filteredProductsProvider` | `Provider<AsyncValue<List<Product>>>` | Catalogue filtré + trié |
| `cartProvider` | `NotifierProvider<CartNotifier, CartState>` | Gère le panier |
| `favoritesProvider` | `NotifierProvider<FavoritesNotifier, FavoritesState>` | Gère les favoris (persistants) |
| `profileProvider` | `FutureProvider<User>` | Charge le profil utilisateur |
| `appRouterProvider` | `Provider<GoRouter>` | Router + transitions |

> Liste complète (27 providers) et documentation détaillée : **[docs/providers.md](docs/providers.md)**

## 🚀 Installation

```bash
# 1. Cloner le dépôt
git clone https://github.com/raharison-joshue-agape/E-commerce-App.git
cd e_commerce_app

# 2. Récupérer les dépendances
flutter pub get

# 3. Lancer l'application
flutter run
```

> Prérequis : Flutter SDK ≥ 3.12 (Dart ≥ 3.12). Plateformes supportées : Android, iOS, Web, Windows.

### Exécuter les tests

```bash
flutter analyze
flutter test
```

## 📦 Dépendances principales

| Package | Version | Rôle |
| --- | --- | --- |
| [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) | ^3.4.2 | Gestion d'état (providers, notifiers) |
| [go_router](https://pub.dev/packages/go_router) | ^17.4.0 | Routage déclaratif + navigation par onglets |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | ^2.5.5 | Persistance locale des favoris |
| [intl](https://pub.dev/packages/intl) | ^0.20.3 | Formatage des prix |

## 📸 Captures d'écran

| Accueil | Produits | Filtres & tri |
| :-: | :-: | :-: |
| ![Accueil](screenshots/01_home.png) | ![Produits](screenshots/02_products.png) | ![Filtres](screenshots/03_filters.png) |

| Détail produit | Panier | Favoris |
| :-: | :-: | :-: |
| ![Détail](screenshots/04_product_detail.png) | ![Panier](screenshots/05_cart.png) | ![Favoris](screenshots/06_favorites.png) |

| Profil |
| :-: |
| ![Profil](screenshots/07_profile.png) |

## 🧠 Choix techniques

- **Riverpod** — gestion d'état moderne, compile-safe, testable, avec rafraîchissement ciblé (`select`) et injection de dépendances intégrée.
- **AsyncValue** — représentation explicite des états `loading` / `error` / `data`, garantissant une gestion uniforme des états asynchrones (skeletons, vues d'erreur, données).
- **Repository Pattern** — découplage entre l'UI et la source de données : les datasources mock peuvent être remplacées par une vraie API sans impact sur la présentation.
- **Feature-First** — code organisé par fonctionnalité métier (évolutivité, lisibilité, testabilité).
- **GoRouter avec StatefulShellRoute** — navigation à onglets performante (état préservé par onglet via `IndexedStack`) et transitions de pages fluides.

## 🔮 Améliorations possibles

- **Authentification** (Firebase Auth, connexion réelle).
- **API réelle** (REST/GraphQL) en remplacement des datasources mock.
- **Paiement** (Stripe, PayPal) et tunnel de commande complet.
- **Historique des commandes** persistant.
- **Synchronisation cloud** des favoris et du panier (multi-appareils).
- **Notifications push** et promotions personnalisées.
- **Optimisations** : `flutter_lints` étendu, couverture de test CI.

## 📄 Licence

Distribué sous licence **MIT** — voir [LICENSE](LICENSE).

## 🧪 Documentation

- [Checklist de conformité](docs/checklist.md)
- [Documentation des providers](docs/providers.md)
- [Tests manuels](docs/manual_tests.md)
