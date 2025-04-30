import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmerEffect extends StatelessWidget {
  const CategoryShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xff868484),
                    width: 0.4,
                  ),
                  color: Colors.white,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.category, // Placeholder icon
                    color: Colors.black,
                    size: 33,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const SizedBox(
                width: 70,
                child: Text(
                  "Loading...", // Placeholder text
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )
        ,
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xff868484),
                    width: 0.4,
                  ),
                  color: Colors.white,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.category, // Placeholder icon
                    color: Colors.black,
                    size: 33,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const SizedBox(
                width: 70,
                child: Text(
                  "Loading...", // Placeholder text
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xff868484),
                    width: 0.4,
                  ),
                  color: Colors.white,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.category, // Placeholder icon
                    color: Colors.black,
                    size: 33,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const SizedBox(
                width: 70,
                child: Text(
                  "Loading...", // Placeholder text
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
