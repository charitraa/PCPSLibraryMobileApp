import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WishlistWidget extends StatelessWidget {
  final String title;
  final String author;
  final String image;
  final int rating;
  final String genre;
  final String available;

  const WishlistWidget({
    required this.title,
    required this.author,
    required this.image,
    required this.rating,
    required this.genre,
    required this.available,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> titleWords = title.split(" ");
    String truncatedTitle =
        titleWords.length > 4 ? "${titleWords.take(5).join(" ")}..." : title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        width:80,
                        height: 120,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          truncatedTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "By $author",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            rating,
                            (index) => const Icon(Icons.star,
                                color: Colors.amber, size: 15),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                genre,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                        Text(
                         available,
                          style: TextStyle(
                            color:Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,

                          ),
                        ),
                        Text('reservationDate')
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
