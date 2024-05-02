import 'package:flutter/material.dart';

class StarsWidget extends StatelessWidget {
  final double? rating;
  final double starSize;
  final Color starColor;
  const StarsWidget(
      {super.key,
        this.rating,
        required this.starSize,
        required this.starColor});

  @override
  Widget build(BuildContext context) {
    return buildStarsBasedOnRating();
  }

  Widget buildEmptyStar() => Icon(
    Icons.star_border,
    color: starColor,
    size: starSize,
  );

  Widget buildHalfStar() => Icon(
    Icons.star_half,
    color: starColor,
    size: starSize,
  );

  Widget buildFullStar() => Icon(
    Icons.star,
    color: starColor,
    size: starSize,
  );

  Widget buildStarsBasedOnRating() => rating! >= 0 && rating! < 0.5
      ? Row(
    children: [for (int i = 0; i < 5; i++) buildEmptyStar()],
  )
      : rating! >= 0.5 && rating! < 1
      ? Row(
    children: [
      buildHalfStar(),
      for (int i = 0; i < 4; i++) buildEmptyStar(),
    ],
  )
      : rating! >= 1 && rating! < 1.5
      ? Row(
    children: [
      buildFullStar(),
      for (int i = 0; i < 4; i++) buildEmptyStar(),
    ],
  )
      : rating! >= 1.5 && rating! < 2
      ? Row(
    children: [
      buildFullStar(),
      buildHalfStar(),
      for (int i = 0; i < 3; i++) buildEmptyStar(),
    ],
  )
      : rating! >= 2 && rating! < 2.5
      ? Row(
    children: [
      for (int i = 0; i < 2; i++) buildFullStar(),
      for (int i = 0; i < 3; i++) buildEmptyStar(),
    ],
  )
      : rating! >= 2.5 && rating! < 3
      ? Row(
    children: [
      for (int i = 0; i < 2; i++) buildFullStar(),
      buildHalfStar(),
      for (int i = 0; i < 2; i++) buildEmptyStar(),
    ],
  )
      : rating! >= 3 && rating! < 3.5
      ? Row(
    children: [
      for (int i = 0; i < 3; i++) buildFullStar(),
      for (int i = 0; i < 2; i++)
        buildEmptyStar(),
    ],
  )
      : rating! >= 3.5 && rating! < 4
      ? Row(
    children: [
      for (int i = 0; i < 3; i++)
        buildFullStar(),
      buildHalfStar(),
      buildEmptyStar(),
    ],
  )
      : rating! >= 4 && rating! < 4.5
      ? Row(
    children: [
      for (int i = 0; i < 4; i++)
        buildFullStar(),
      buildEmptyStar(),
    ],
  )
      : rating! >= 4.5 && rating! < 5
      ? Row(
    children: [
      for (int i = 0; i < 4; i++)
        buildFullStar(),
      buildHalfStar(),
    ],
  )
      : Row(
    children: [
      for (int i = 0; i < 5; i++)
        buildFullStar(),
    ],
  );
}
