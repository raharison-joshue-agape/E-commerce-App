import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_filters_providers.dart';

class CategoryFilter extends ConsumerWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final selected = ref.watch(selectedCategoryProvider);
    final notifier = ref.read(productFiltersProvider.notifier);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ChoiceChip(
              label: const Text('Tous'),
              selected: selected == null,
              onSelected: (_) => notifier.setCategory(null),
            );
          }
          final category = categories[index - 1];
          return ChoiceChip(
            label: Text(category),
            selected: selected == category,
            onSelected: (_) => notifier.setCategory(category),
          );
        },
      ),
    );
  }
}
