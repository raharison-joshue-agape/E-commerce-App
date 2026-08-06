import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency.dart';
import '../providers/product_filters_providers.dart';

class PriceRangeFilter extends ConsumerWidget {
  const PriceRangeFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bounds = ref.watch(priceBoundsProvider);
    final range = ref.watch(priceRangeProvider);
    final notifier = ref.read(productFiltersProvider.notifier);

    final start = range.start.clamp(bounds.start, bounds.end).toDouble();
    final end = range.end.clamp(bounds.start, bounds.end).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Prix',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '${formatPrice(start)} – ${formatPrice(end)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        RangeSlider(
          values: RangeValues(start, end),
          min: bounds.start,
          max: bounds.end,
          labels: RangeLabels(formatPrice(start), formatPrice(end)),
          onChanged: (values) => notifier.setPriceRange(values),
        ),
      ],
    );
  }
}
