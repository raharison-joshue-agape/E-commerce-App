import 'package:flutter/material.dart';

class ProductCategory {
  const ProductCategory({
    required this.name,
    required this.icon,
    required this.color,
  });

  final String name;
  final IconData icon;
  final Color color;
}

const List<ProductCategory> kProductCategories = [
  ProductCategory(
    name: 'Smartphones',
    icon: Icons.smartphone,
    color: Color(0xFF4F46E5),
  ),
  ProductCategory(
    name: 'Laptops',
    icon: Icons.laptop_mac,
    color: Color(0xFF2563EB),
  ),
  ProductCategory(
    name: 'Gaming',
    icon: Icons.sports_esports,
    color: Color(0xFF7C3AED),
  ),
  ProductCategory(
    name: 'Audio',
    icon: Icons.headphones,
    color: Color(0xFF0D9488),
  ),
  ProductCategory(
    name: 'Fashion',
    icon: Icons.checkroom,
    color: Color(0xFFDB2777),
  ),
  ProductCategory(
    name: 'Accessories',
    icon: Icons.watch,
    color: Color(0xFFD97706),
  ),
];

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 84,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(category.icon, color: category.color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
