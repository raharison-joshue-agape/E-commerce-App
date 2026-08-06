import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_filters_providers.dart';

class AvailabilityFilter extends ConsumerWidget {
  const AvailabilityFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onlyAvailable = ref.watch(availabilityProvider);
    final notifier = ref.read(productFiltersProvider.notifier);

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Produits disponibles uniquement'),
      subtitle: const Text('Masquer les articles en rupture de stock'),
      value: onlyAvailable,
      onChanged: notifier.setOnlyAvailable,
    );
  }
}
