import 'package:flutter/material.dart';

import '../../../core/utils/color_utils.dart';

class ColorSelector extends StatefulWidget {
  const ColorSelector({super.key, required this.colors});

  final List<String> colors;

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Couleurs',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(widget.colors.length, (index) {
            final isSelected = index == _selectedIndex;
            return GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: parseHexColor(widget.colors[index]),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outlineVariant,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }
}
