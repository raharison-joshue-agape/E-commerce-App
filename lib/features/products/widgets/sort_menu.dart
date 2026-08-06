import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_sort_option.dart';
import '../providers/product_filters_providers.dart';

extension on ProductSortOption {
  IconData get icon => switch (this) {
        ProductSortOption.relevance => Icons.auto_awesome,
        ProductSortOption.priceAscending => Icons.arrow_upward,
        ProductSortOption.priceDescending => Icons.arrow_downward,
        ProductSortOption.nameAscending => Icons.sort_by_alpha,
        ProductSortOption.nameDescending => Icons.arrow_back,
        ProductSortOption.bestRated => Icons.star,
        ProductSortOption.bestDiscount => Icons.local_offer,
      };
}

class SortMenu extends ConsumerWidget {
  const SortMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final sort = ref.watch(sortProvider);
    final notifier = ref.read(productFiltersProvider.notifier);

    return PopupMenuButton<ProductSortOption>(
      tooltip: 'Trier les produits',
      initialValue: sort,
      onSelected: notifier.setSort,
      itemBuilder: (context) => [
        for (final option in ProductSortOption.values)
          PopupMenuItem(
            value: option,
            child: Row(
              children: [
                Icon(
                  option.icon,
                  size: 20,
                  color: option == sort ? colors.primary : colors.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(option.label),
              ],
            ),
          ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: colors.outlineVariant),
          borderRadius: BorderRadius.circular(20),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 140;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(sort.icon, size: 18, color: colors.primary),
                if (!compact) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      sort.label,
                      style: theme.textTheme.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 2),
                ],
                const Icon(Icons.arrow_drop_down),
              ],
            );
          },
        ),
      ),
    );
  }
}
