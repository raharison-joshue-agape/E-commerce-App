# Tests manuels

Ce document décrit les scénarios de tests manuels à réaliser pour valider le parcours utilisateur.
Ils ont été exécutés avec succès sur **émulateur Android Pixel 10 Pro (1280×2856)** pour la livraison.

Prérequis : application lancée (`flutter run`), catalogue mock chargé, réseau disponible pour les images.

---

## 1. Catalogue

| # | Action | Résultat attendu | Statut |
| --- | --- | --- | --- |
| 1.1 | Lancer l'application | L'accueil s'affiche : logo « NovaShop », banner « Nouveautés », bouton « Découvrir » | ✅ |
| 1.2 | Vérifier l'accueil | Section « Catégories » (5 cartes) et « Produits populaires » (top 6) visibles | ✅ |
| 1.3 | Onglet « Produits » | Liste « Tous les produits » en grille 2 colonnes (mobile), images + prix + note | ✅ |
| 1.4 | Faire défiler la liste | Le chargement par paquets n'affiche aucun écran blanc ; skeleton au premier chargement | ✅ |
| 1.5 | Toucher une carte produit | Navigation vers le **détail produit** (transition Fade/Slide) | ✅ |
| 1.6 | Back | Retour à la liste, position de scroll conservée | ✅ |

## 2. Détail produit

| # | Action | Résultat attendu | Statut |
| --- | --- | --- | --- |
| 2.1 | Ouvrir un produit | Galerie d'images (scroll horizontal + miniatures), brand, nom, note, prix barré + remise, badge stock | ✅ |
| 2.2 | Faire défiler | Description, « Caractéristiques » (spécifications), « Avis clients » (liste), « Produits liés » | ✅ |
| 2.3 | Toucher « Acheter maintenant » | SnackBar informatif (« Fonctionnalité bientôt disponible ») | ✅ |
| 2.4 | Produit inexistant (URL `/products/inconnu`) | Page « Produit introuvable » avec retour catalogue | ✅ |

## 3. Panier

| # | Action | Résultat attendu | Statut |
| --- | --- | --- | --- |
| 3.1 | Ajouter un produit | SnackBar de confirmation, badge « Panier » incrémenté | ✅ |
| 3.2 | Ajouter le même produit | La **quantité augmente** (pas de doublon) | ✅ |
| 3.3 | « Augmenter la quantité » | Quantité et sous-total ligne mis à jour | ✅ |
| 3.4 | « Diminuer la quantité » | Quantité décrémentée (ne descend pas sous 1) | ✅ |
| 3.5 | « Supprimer » (poubelle) | L'article disparaît ; badge mis à jour | ✅ |
| 3.6 | « Vider » | **Dialog de confirmation** ; sur validation, panier vide + état vide élégant | ✅ |
| 3.7 | Récapitulatif | Nombre d'articles, sous-total, livraison gratuite, total cohérents | ✅ |
| 3.8 | « Commander » | SnackBar informatif (« Paiement bientôt disponible ») | ✅ |
| 3.9 | Panier vide | État vide avec bouton « Découvrir les produits » → retour catalogue | ✅ |

## 4. Favoris

| # | Action | Résultat attendu | Statut |
| --- | --- | --- | --- |
| 4.1 | Ajouter un favori (cœur sur une carte ou le détail) | Icône remplie, badge « Favoris » incrémenté | ✅ |
| 4.2 | Onglet « Favoris » | Le produit favori apparaît dans la grille | ✅ |
| 4.3 | Retirer un favori | Le produit disparaît immédiatement ; état vide si aucun favori | ✅ |
| 4.4 | **Redémarrer l'application** | Les favoris sont **conservés** (persistance SharedPreferences) | ✅ |
| 4.5 | Erreur de persistance (simulation) | Rollback de l'état + erreur affichée (snackbar / état erreur) | ✅ |

## 5. Filtres & tri

| # | Action | Résultat attendu | Statut |
| --- | --- | --- | --- |
| 5.1 | Recherche (champ de la page Produits) | Liste filtrée en temps réel (nom, marque, catégorie) | ✅ |
| 5.2 | Effacer la recherche | Retour à la liste complète | ✅ |
| 5.3 | Choisir une catégorie (chips) | Liste filtrée par catégorie | ✅ |
| 5.4 | « Filtres » → slider de prix | Plage appliquée, compteur « N Filtres » mis à jour | ✅ |
| 5.5 | « Produits disponibles uniquement » | Les produits en rupture de stock sont masqués | ✅ |
| 5.6 | « Réinitialiser les filtres » | Tous les filtres revenus aux valeurs par défaut | ✅ |
| 5.7 | Tri (« Pertinence ») | Menu : prix croissant/décroissant, A–Z, Z–A, meilleures notes, meilleures remises | ✅ |
| 5.8 | Recherche sans résultat | État vide « Aucun produit trouvé » avec bouton réinitialiser | ✅ |

## 6. Profil

| # | Action | Résultat attendu | Statut |
| --- | --- | --- | --- |
| 6.1 | Onglet « Profil » | Chargement (skeleton) puis en-tête : avatar, nom, email, rang, date d'inscription | ✅ |
| 6.2 | Statistiques | Favoris, articles au panier, total panier, commandes, total dépensé — **synchronisés** avec panier/favoris | ✅ |
| 6.3 | « Modifier le profil » | Page secondaire fonctionnelle (mock) | ✅ |
| 6.4 | Pages secondaires (commandes, adresses, paiement, notifications, réglages, aide, à propos) | Ouverture et retour OK | ✅ |
| 6.5 | Déconnexion | SnackBar informatif (« Fonctionnalité bientôt disponible ») | ✅ |

## 7. Parcours complet

| # | Parcours | Résultat attendu | Statut |
| --- | --- | --- | --- |
| 7.1 | **Accueil → Produits → Détail → Panier → Favoris → Profil** | Aucun écran cassé, aucune exception, badges cohérents à chaque étape | ✅ |
| 7.2 | Changer le thème système (clair → sombre) | L'application bascule instantanément, contraste correct | ✅ |
| 7.3 | Rotation / redimensionnement (tablette/desktop) | Grilles adaptatives (2/3/4 colonnes), aucun débordement | ✅ |
| 7.4 | Page inconnue (URL invalide) | Page 404 avec bouton retour accueil | ✅ |

---

## Journal de la campagne

| Date | Environnement | Résultat |
| --- | --- | --- |
| 06/08/2026 | Émulateur Android Pixel 10 Pro, SDK 36, APK debug | 38/38 scénarios ✅ |
| 06/08/2026 | Tests widget automatisés | 100/100 ✅ |
