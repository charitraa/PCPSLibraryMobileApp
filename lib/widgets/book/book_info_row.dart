import 'package:flutter/material.dart';

class BookInfoRow extends StatefulWidget {
  final String title, value;
  const BookInfoRow({super.key, required this.title, required this.value});

  @override
  State<BookInfoRow> createState() => _BookInfoRowState();
}

class _BookInfoRowState extends State<BookInfoRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            softWrap: true,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(widget.value,style: const TextStyle(fontSize: 13), softWrap: true, overflow: TextOverflow.visible),
        ),
      ],
    );
  }
}
