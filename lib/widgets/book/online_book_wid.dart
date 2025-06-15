import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OnlineBookWid extends StatefulWidget {
  final String bookImage, title;
  final VoidCallback? onTap;
  const OnlineBookWid(
      {super.key,
        required this.bookImage,
        required this.title,
          this.onTap});

  @override
  State<OnlineBookWid> createState() => _BookWidgetState();
}

class _BookWidgetState extends State<OnlineBookWid> {
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
        height: 200,
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
              child: CachedNetworkImage(
                imageUrl: widget.bookImage,
                width: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
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
          ],
        ),
      ),
    );
  }
}
