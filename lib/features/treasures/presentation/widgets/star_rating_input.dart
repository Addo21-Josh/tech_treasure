import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// 1 to 5 star rating display and input selector for Content Potential.
class StarRatingInput extends StatelessWidget {
  final int rating;
  final ValueChanged<int>? onRatingChanged;
  final double size;

  const StarRatingInput({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isFilled = starIndex <= rating;

        final icon = Icon(
          isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
          color: isFilled ? AppColors.treasureGold : AppColors.darkTextMuted,
          size: size,
        );

        if (onRatingChanged != null) {
          return IconButton(
            iconSize: size,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            constraints: BoxConstraints(
              minWidth: size + 6,
              minHeight: size + 6,
            ),
            icon: icon,
            onPressed: () => onRatingChanged!(starIndex),
          );
        }

        return Padding(padding: const EdgeInsets.only(right: 2), child: icon);
      }),
    );
  }
}
