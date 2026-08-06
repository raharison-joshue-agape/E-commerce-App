import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../models/user.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_section.dart';
import '../widgets/profile_statistics.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Fonctionnalité bientôt disponible')),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon profil',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ProfileErrorView(
          onRetry: () => ref.invalidate(profileProvider),
        ),
        data: (user) => _ProfileContent(
          user: user,
          onEditPressed: () => _showComingSoon(context),
          onLogoutPressed: () => _showComingSoon(context),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.user,
    required this.onEditPressed,
    required this.onLogoutPressed,
  });

  final User user;
  final VoidCallback onEditPressed;
  final VoidCallback onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: ListView(
          padding: const EdgeInsets.only(top: 16, bottom: 32),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ProfileHeader(
                user: user,
                onEdit: onEditPressed,
              ),
            ),
            ProfileSection(
              title: 'Statistiques',
              children: [ProfileStatistics(user: user)],
            ),
            ProfileSection(
              title: 'Informations personnelles',
              children: [
                ProfileInfoCard(
                  entries: [
                    ProfileInfoEntry(
                      icon: Icons.person_outline,
                      label: 'Nom',
                      value: user.fullName,
                    ),
                    ProfileInfoEntry(
                      icon: Icons.phone_outlined,
                      label: 'Téléphone',
                      value: user.phone,
                    ),
                    ProfileInfoEntry(
                      icon: Icons.home_outlined,
                      label: 'Adresse',
                      value: user.address,
                    ),
                    ProfileInfoEntry(
                      icon: Icons.location_city_outlined,
                      label: 'Ville',
                      value: user.city,
                    ),
                    ProfileInfoEntry(
                      icon: Icons.public_outlined,
                      label: 'Pays',
                      value: user.country,
                    ),
                    ProfileInfoEntry(
                      icon: Icons.local_post_office_outlined,
                      label: 'Code postal',
                      value: user.postalCode,
                    ),
                  ],
                ),
              ],
            ),
            ProfileSection(
              title: 'Menu',
              children: [
                _ProfileMenuCard(onLogoutPressed: onLogoutPressed),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuCard extends StatelessWidget {
  const _ProfileMenuCard({required this.onLogoutPressed});

  final VoidCallback onLogoutPressed;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      ProfileMenuTile(
        icon: Icons.receipt_long_outlined,
        title: 'Mes commandes',
        subtitle: 'Suivez et gérez vos commandes',
        onTap: () => context.push(AppRoutes.orders),
      ),
      ProfileMenuTile(
        icon: Icons.favorite_outline,
        title: 'Mes favoris',
        subtitle: 'Vos produits enregistrés',
        onTap: () => context.go(AppRoutes.favorites),
      ),
      ProfileMenuTile(
        icon: Icons.shopping_cart_outlined,
        title: 'Mon panier',
        subtitle: 'Vos articles sélectionnés',
        onTap: () => context.go(AppRoutes.cart),
      ),
      ProfileMenuTile(
        icon: Icons.location_on_outlined,
        title: 'Adresses',
        subtitle: 'Gérez vos adresses de livraison',
        onTap: () => context.push(AppRoutes.addresses),
      ),
      ProfileMenuTile(
        icon: Icons.credit_card_outlined,
        title: 'Paiements',
        subtitle: 'Moyens de paiement enregistrés',
        onTap: () => context.push(AppRoutes.paymentMethods),
      ),
      ProfileMenuTile(
        icon: Icons.notifications_outlined,
        title: 'Notifications',
        subtitle: 'Gérez vos préférences de notification',
        onTap: () => context.push(AppRoutes.notifications),
      ),
      ProfileMenuTile(
        icon: Icons.settings_outlined,
        title: 'Paramètres',
        subtitle: 'Préférences de l\'application',
        onTap: () => context.push(AppRoutes.settings),
      ),
      ProfileMenuTile(
        icon: Icons.help_outline,
        title: 'Aide',
        subtitle: 'Questions fréquentes et support',
        onTap: () => context.push(AppRoutes.help),
      ),
      ProfileMenuTile(
        icon: Icons.info_outline,
        title: 'À propos',
        subtitle: 'Version et informations',
        onTap: () => context.push(AppRoutes.about),
      ),
      ProfileMenuTile(
        icon: Icons.logout,
        title: 'Déconnexion',
        subtitle: 'Quitter votre compte',
        destructive: true,
        onTap: onLogoutPressed,
      ),
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              const Divider(height: 1, indent: 68, endIndent: 16),
          ],
        ],
      ),
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  const _ProfileErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: colors.onErrorContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Impossible de charger votre profil.',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Veuillez réessayer dans quelques instants.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
