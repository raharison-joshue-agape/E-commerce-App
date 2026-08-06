import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductImageGallery extends StatefulWidget {
  const ProductImageGallery({super.key, required this.product});

  final Product product;

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  late final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectImage(int index) {
    setState(() => _currentIndex = index);
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final images = widget.product.images;

    return Column(
      children: [
        ColoredBox(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Hero(
            tag: 'product-image-${widget.product.id}',
            child: SizedBox(
              height: 320,
              child: PageView.builder(
                controller: _controller,
                itemCount: images.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) => Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 64,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (images.length > 1)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final isSelected = index == _currentIndex;
                return GestureDetector(
                  onTap: () => _selectImage(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_outlined),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
