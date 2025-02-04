import 'package:flutter/material.dart';

class TextWidget extends StatefulWidget {
  final String text,age,gender;
  final String? phone;
  const TextWidget({super.key, required this.text, required this.age, required this.gender,  this.phone});

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.text),
        Text(widget.age),
        Text(widget.gender),


      ],
    );
  }
}
