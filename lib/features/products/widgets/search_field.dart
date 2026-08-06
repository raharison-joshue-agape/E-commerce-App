import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_filters_providers.dart';

class SearchField extends ConsumerStatefulWidget {
  const SearchField({super.key});

  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    _focusNode.requestFocus();
    ref.read(productFiltersProvider.notifier).clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(searchQueryProvider, (previous, next) {
      if (_controller.text != next) {
        _controller.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        );
      }
    });

    final query = ref.watch(searchQueryProvider);
    final colors = Theme.of(context).colorScheme;

    return SearchBar(
      controller: _controller,
      focusNode: _focusNode,
      hintText: 'Rechercher un produit...',
      leading: const Padding(
        padding: EdgeInsets.only(left: 8),
        child: Icon(Icons.search),
      ),
      trailing: [
        if (query.isNotEmpty)
          IconButton(
            tooltip: 'Effacer la recherche',
            icon: const Icon(Icons.close),
            onPressed: _clear,
          ),
      ],
      onChanged: (value) =>
          ref.read(productFiltersProvider.notifier).setSearchQuery(value),
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(colors.surfaceContainerLow),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
