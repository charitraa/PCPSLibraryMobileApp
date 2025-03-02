import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookInfoColumn extends StatefulWidget {
  final String title, value;
  const BookInfoColumn({super.key, required this.title, required this.value});

  @override
  State<BookInfoColumn> createState() => _BookInfoColumnState();
}

class _BookInfoColumnState extends State<BookInfoColumn> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Text(widget.title, style: const TextStyle(fontSize:13,fontWeight: FontWeight.bold,color: Colors.grey),),
        const SizedBox(height: 5,),
        Text(widget.value,style: const TextStyle(fontSize:12,fontWeight: FontWeight.bold,),)
      ],
    );
  }
}
