import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/colors.dart';

import '../custom_shimmer_effect.dart';

class BookWidget extends StatefulWidget {
  final String bookImage, title, author;
  final VoidCallback? onTap;
  const BookWidget(
      {super.key,
        required this.bookImage,
        required this.title,
        required this.author,  this.onTap});

  @override
  State<BookWidget> createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget> {
  @override
  Widget build(BuildContext context) {
    List<String> titleWords = widget.title.split(" ");
    String truncatedTitle = titleWords.length > 5
        ? "${titleWords.take(5).join(" ")}..."
        : widget.title;

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: 100,
        height: 220,
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
            SizedBox(
              height: 122,
              child: Image.network(
                widget.bookImage,
                width: 120,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CustomShimmerLoading(
                      width: 120.0,
                      height: 122,
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
            const SizedBox(height: 2),
            Text(
              truncatedTitle,
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.author,
              style: const TextStyle(
                fontSize: 9,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
