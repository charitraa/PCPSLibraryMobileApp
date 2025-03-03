import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

class ReviewCard extends StatefulWidget {
  final String? image, name, text;
  const ReviewCard({super.key, required this.image, required this.name, required this.text});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                     Text(
                      widget.name??'',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.star,
                        color: Colors.orange[700], size: 18),
                    Icon(Icons.star,
                        color: Colors.orange[700], size: 18),
                    Icon(Icons.star,
                        color: Colors.orange[700], size: 18),
                    Icon(Icons.star,
                        color: Colors.orange[700], size: 18),
                    const Icon(Icons.star_half,
                        color: Colors.orange, size: 18),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  "June 5, 2019",
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                 Text(
                 widget.text??'',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.chat,
                        size: 16, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      "Reply",
                      style: TextStyle(
                          fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: -15,
            left: -10,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.image??'',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error, size: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
