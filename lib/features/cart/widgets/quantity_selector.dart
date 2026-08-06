import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.remove,
            tooltip: 'Diminuer la quantité',
            onPressed: quantity > 1 ? onDecrease : null,
          ),
          SizedBox(
            width: 32,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                '$quantity',
                key: ValueKey(quantity),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),
            ),
          ),
          _QuantityButton(
            icon: Icons.add,
            tooltip: 'Augmenter la quantité',
            onPressed: onIncrease,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      iconSize: 18,
      color: onPressed == null
          ? Theme.of(context).colorScheme.outline
          : Theme.of(context).colorScheme.primary,
      icon: Icon(icon),
    );
  }
}
