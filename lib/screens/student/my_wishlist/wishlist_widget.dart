import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/colors.dart';

import '../../../widgets/custom_shimmer_effect.dart';

class WishlistWidget extends StatelessWidget {
  final String title,publicationYear;
  final String image;
  final String genre;
  final VoidCallback? onTap;
  final String status;

  const WishlistWidget({
    required this.title,
    required this.image,
    required this.genre,
    required this.status,
    super.key, this.onTap, required this.publicationYear,
  });

  @override
  Widget build(BuildContext context) {
    List<String> titleWords = title.split(" ");
    String truncatedTitle =
        titleWords.length > 4 ? "${titleWords.take(5).join(" ")}..." : title;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
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
                        borderRadius: BorderRadius.circular(5),
                        child:Image.network(
                          image,
                          width: 70,
                          height: 90,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child:CustomShimmerLoading(
                                width: 70.0,
                                height: 90,
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 70,
                            height: 90,
                            color: Colors.deepOrange,
                            child: const Center(
                              child: Icon(
                                Icons.book,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),

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
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
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
                                  status,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Publication Year : $publicationYear",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),

                          Row(
                            children: [
                              const Text(
                                'Reserved on : ',
                                style:  TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                genre,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
