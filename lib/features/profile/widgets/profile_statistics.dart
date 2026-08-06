import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency.dart';
import '../../cart/providers/cart_providers.dart';
import '../../favorites/providers/favorites_providers.dart';
import '../models/user.dart';
import 'statistic_card.dart';

class ProfileStatistics extends ConsumerWidget {
  const ProfileStatistics({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteCount = ref.watch(
      favoritesProvider.select((state) => state.favoriteCount),
    );
    final cart = ref.watch(cartProvider);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 12.0;
            final columns = switch (constraints.maxWidth) {
              >= 700 => 5,
              >= 480 => 3,
              _ => 2,
            };
            final itemWidth =
                (constraints.maxWidth - spacing * (columns - 1)) / columns;

            final stats = <StatisticCard>[
              StatisticCard(
                icon: Icons.favorite_outline,
                value: '$favoriteCount',
                label: 'Favoris',
              ),
              StatisticCard(
                icon: Icons.shopping_cart_outlined,
                value: '${cart.itemCount}',
                label: 'Articles au panier',
              ),
              StatisticCard(
                icon: Icons.payments_outlined,
                value: formatPrice(cart.total),
                label: 'Total panier',
              ),
              StatisticCard(
                icon: Icons.receipt_long_outlined,
                value: '${user.totalOrders}',
                label: 'Commandes',
              ),
              StatisticCard(
                icon: Icons.account_balance_wallet_outlined,
                value: formatPrice(user.totalSpent),
                label: 'Total dépensé',
                highlighted: true,
              ),
            ];

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final stat in stats)
                  SizedBox(width: itemWidth, child: stat),
              ],
            );
          },
        ),
      ),
    );
  }
}
