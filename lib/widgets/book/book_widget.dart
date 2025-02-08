import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookWidget extends StatefulWidget {
  final String bookImage, title, author;
  const BookWidget(
      {super.key,
      required this.bookImage,
      required this.title,
      required this.author});

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

    return Container(
      width: 100,
      height: 175,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1.6,
            blurRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: Image(
              image: AssetImage(widget.bookImage),
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            truncatedTitle,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis, // Handle overflow if needed
          ),
          // Author Text
          Text(
            widget.author,
            style: const TextStyle(
              fontSize: 9,
              fontFamily: 'poppins',
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Handle text overflow
          ),
        ],
      ),
    );
  }
}
