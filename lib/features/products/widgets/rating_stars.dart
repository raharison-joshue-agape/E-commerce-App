import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.size = 16});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final icon = rating >= index + 1
            ? Icons.star
            : rating >= index + 0.5
            ? Icons.star_half
            : Icons.star_border;
        return Icon(icon, size: size, color: Colors.amber);
      }),
    );
  }
}
