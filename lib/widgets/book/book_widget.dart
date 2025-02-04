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
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: Image(
              image: AssetImage(widget.bookImage),
              width: 120,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Text(widget.title,style: const TextStyle(fontSize: 10,fontFamily: 'poppins',fontWeight: FontWeight.bold),),
          Text(widget.author,style: const TextStyle(fontSize: 10,fontFamily: 'poppins',fontWeight: FontWeight.bold),),

        ],
      ),
    );
  }
}
