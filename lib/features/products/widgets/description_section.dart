import 'package:flutter/material.dart';

class DescriptionSection extends StatefulWidget {
  const DescriptionSection({super.key, required this.description});

  final String description;

  @override
  State<DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  static const int _maxVisibleChars = 160;
  static const int _collapsedMaxLines = 4;

  bool _expanded = false;

  bool get _isLong => widget.description.length > _maxVisibleChars;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.topCenter,
          child: Text(
            widget.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
              height: 1.5,
            ),
            maxLines: _expanded ? null : _collapsedMaxLines,
            overflow: _expanded ? null : TextOverflow.ellipsis,
          ),
        ),
        if (_isLong)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(_expanded ? 'Voir moins' : 'Voir plus'),
            ),
          ),
      ],
    );
  }
}
