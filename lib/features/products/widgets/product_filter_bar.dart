import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_filters_providers.dart';
import 'availability_filter.dart';
import 'category_filter.dart';
import 'price_range_filter.dart';
import 'search_field.dart';
import 'sort_menu.dart';

class ProductFilterBar extends ConsumerStatefulWidget {
  const ProductFilterBar({super.key});

  @override
  ConsumerState<ProductFilterBar> createState() => _ProductFilterBarState();
}

class _ProductFilterBarState extends ConsumerState<ProductFilterBar> {
  bool _filtersExpanded = false;

  void _toggleFilters() {
    setState(() => _filtersExpanded = !_filtersExpanded);
  }

  void _resetFilters() {
    setState(() => _filtersExpanded = false);
    ref.read(productFiltersProvider.notifier).resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final activeCount = ref.watch(activeFilterCountProvider);

    return ColoredBox(
      color: colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: SearchField(),
          ),
          const SizedBox(height: 8),
          const CategoryFilter(),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: _toggleFilters,
                  icon: Badge.count(
                    count: activeCount,
                    isLabelVisible: activeCount > 0,
                    child: Icon(
                      _filtersExpanded ? Icons.expand_less : Icons.tune,
                    ),
                  ),
                  label: const Text('Filtres'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: const SortMenu(),
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _filtersExpanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const PriceRangeFilter(),
                        const Divider(height: 24),
                        const AvailabilityFilter(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: activeCount > 0 ? _resetFilters : null,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Réinitialiser les filtres'),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
