import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookSkeletonGrid extends StatelessWidget {
  final int itemCount;

  const BookSkeletonGrid({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          double itemWidth = (constraints.maxWidth - (10 * 2)) / 3;
          double itemHeight = 180;
          double aspectRatio = itemWidth / itemHeight;

          return GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
              childAspectRatio: aspectRatio,
            ),
            itemCount: itemCount,
            itemBuilder: (context, index) => buildBookWidgetShimmer(),
          );
        });
  }
}

Widget buildBookWidgetShimmer() {
  return Container(
    width: 100,
    height: 180,
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 1.5,
          offset: const Offset(2, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 12,
            width: 80,
            color: Colors.white,
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 10,
            width: 60,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
