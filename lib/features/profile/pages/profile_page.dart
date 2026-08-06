import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../shared/services/app_snackbar_service.dart';
import '../../../shared/widgets/app_skeletons.dart';
import '../../../shared/widgets/error_state_widget.dart';
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
    AppSnackbarService.show(context, 'Fonctionnalité bientôt disponible');
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
        loading: () => const ProfileSkeleton(),
        error: (error, stackTrace) => ErrorStateWidget(
          title: 'Impossible de charger votre profil.',
          message: 'Veuillez réessayer dans quelques instants.',
          onAction: () => ref.invalidate(profileProvider),
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
              child: ProfileHeader(user: user, onEdit: onEditPressed),
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
              children: [_ProfileMenuCard(onLogoutPressed: onLogoutPressed)],
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
    final colors = Theme.of(context).colorScheme;

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
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Material(
          color: colors.errorContainer.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colors.error.withValues(alpha: 0.35)),
          ),
          clipBehavior: Clip.antiAlias,
          child: ProfileMenuTile(
            icon: Icons.logout,
            title: 'Déconnexion',
            subtitle: 'Quitter votre compte',
            destructive: true,
            onTap: onLogoutPressed,
          ),
        ),
      ),
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 2)
              const Divider(height: 1, indent: 68, endIndent: 16),
          ],
        ],
      ),
    );
  }
}
