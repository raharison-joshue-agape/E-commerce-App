import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key, required this.onDiscoverTap});

  final VoidCallback onDiscoverTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      height: 200,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33566FE0),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2E3A5C), Color(0xFF5C6BC0)],
              ),
            ),
          ),
          Positioned(
            right: -40,
            top: -20,
            child: Icon(
              Icons.shopping_bag,
              size: 180,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            right: 24,
            bottom: 16,
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 12),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  'https://picsum.photos/seed/promo/200/200',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const ColoredBox(color: Color(0xFF5C6BC0));
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.tertiary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Nouveautés',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Découvrez les meilleures offres du moment',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: onDiscoverTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.tertiary,
                    foregroundColor: colors.onTertiary,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('Découvrir'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
