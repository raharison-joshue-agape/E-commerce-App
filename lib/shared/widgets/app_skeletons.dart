import 'package:flutter/material.dart';

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SkeletonBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(width: 56, height: 10),
                SizedBox(height: 8),
                SkeletonBox(width: double.infinity, height: 13),
                SizedBox(height: 6),
                SkeletonBox(width: 96, height: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartSkeleton extends StatelessWidget {
  const CartSkeleton({super.key, this.items = 3});

  final int items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < items; i++) ...[
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const SkeletonBox(width: 64, height: 64, borderRadius: 14),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SkeletonBox(width: double.infinity, height: 14),
                        SizedBox(height: 8),
                        SkeletonBox(width: 120, height: 12),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            SkeletonBox(width: 90, height: 28, borderRadius: 12),
                            Spacer(),
                            SkeletonBox(width: 70, height: 14),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Center(
          child: Column(
            children: [
              SkeletonBox(width: 88, height: 88, borderRadius: 44),
              SizedBox(height: 16),
              SkeletonBox(width: 160, height: 18),
              SizedBox(height: 8),
              SkeletonBox(width: 220, height: 14),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SkeletonBox(width: 120, height: 16),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  const Row(
                    children: [
                      SkeletonBox(width: 40, height: 40, borderRadius: 20),
                      SizedBox(width: 12),
                      Expanded(child: SkeletonBox(width: double.infinity, height: 14)),
                    ],
                  ),
                  if (i < 2) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const SkeletonBox(width: 160, height: 16),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              for (var i = 0; i < 4; i++) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      SkeletonBox(width: 40, height: 40, borderRadius: 20),
                      SizedBox(width: 12),
                      Expanded(child: SkeletonBox(width: double.infinity, height: 14)),
                      SizedBox(width: 12),
                      SkeletonBox(width: 16, height: 16),
                    ],
                  ),
                ),
                if (i < 3) const Divider(height: 1, indent: 68),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
