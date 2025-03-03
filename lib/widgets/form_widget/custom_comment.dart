import 'package:flutter/material.dart';

class CustomCommentField extends StatefulWidget {
  final String text;
  final String hintText;
  final Color outlinedColor;
  final bool? obscureText;
  final Color focusedColor;
  final double width;
  final Widget? suffixicon;
  final String? helper;
  final TextStyle? helperStyle;
  final Icon? prefixicon;
  final Widget? suffixText;
  final TextEditingController? textController;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final int? maxLines; // Added maxLines
  final int? minLines; // Added minLines

  const CustomCommentField({
    super.key,
    required this.hintText,
    required this.outlinedColor,
    this.obscureText,
    required this.focusedColor,
    required this.width,
    required this.text,
    this.textController,
    this.keyboardType,
    this.onChanged,
    this.suffixicon,
    this.prefixicon,
    this.helper,
    this.helperStyle,
    this.suffixText,
    this.maxLines, // Initialize maxLines
    this.minLines, // Initialize minLines
  });

  @override
  State<CustomCommentField> createState() => _CustomCommentFieldState();
}

class _CustomCommentFieldState extends State<CustomCommentField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          TextField(
            controller: widget.textController,
            onChanged: widget.onChanged,
            keyboardType: widget.keyboardType,
            style: const TextStyle(fontFamily: 'poppins', fontSize: 15),
            maxLines: widget.maxLines ?? 1,
            minLines: widget.minLines ?? 1,
            decoration: InputDecoration(
              helperText: widget.helper,
              helperStyle: widget.helperStyle,
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontFamily: 'poppins',
                fontSize: 11,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: widget.outlinedColor,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: widget.focusedColor,
                  width: 1.5,
                ),
              ),
              prefixIcon: widget.prefixicon,
              suffixIcon: widget.suffixicon,
              suffix: widget.suffixText,
            ),
          ),
        ],
      ),
    );
  }
}
