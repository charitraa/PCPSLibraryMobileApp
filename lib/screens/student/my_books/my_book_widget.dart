import 'package:flutter/material.dart';

import '../../../resource/colors.dart';
import '../../../widgets/custom_shimmer_effect.dart';


class MyBookWidget extends StatelessWidget {
  final String title, id;
  final String? checkIn, due, status;
  final String image;
  final VoidCallback? onTap;

  const MyBookWidget({
    required this.title,
    required this.image,
    super.key,
    this.onTap,
    this.checkIn,
    this.due,
    this.status,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    List<String> titleWords = title.split(" ");
    String truncatedTitle =
    titleWords.length > 3 ? "${titleWords.take(5).join(" ")}..." : title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 70,
                    minHeight: 90,
                    maxWidth: 70,
                    maxHeight: 90,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return        Center(
                          child:CustomShimmerLoading(
                            width: 70.0,
                            height: 90,
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                          ),
                        );

                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 120,
                        height: 122,
                        color: AppColors.primary,
                        child: const Center(
                          child: Icon(
                            Icons.book,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),

                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              truncatedTitle,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (status != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: status == 'Available'
                                    ? Colors.red.shade400
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                status!,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'Check In Date : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            checkIn ?? '',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'Due Date : ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            due ?? '',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      if (status == 'Reserved') ...[
                        const SizedBox(height: 4),
                        const Text(
                          "Note: Can't renew, reserved by others",
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}