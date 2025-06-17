import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final double? radius;
  final Color baseColor;
  final Color highlightColor;

  const CustomShimmerLoading({
    super.key,
    this.width,
    this.height,
    this.radius,
    this.baseColor = Colors.grey,
    this.highlightColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          shape: radius != null ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: radius != null ? null : BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}