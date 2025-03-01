import 'package:flutter/material.dart';

import '../resource/colors.dart';

class CustomSearch extends StatefulWidget {
  final String hintText;
  final TextStyle? hintStyle;
  final Color outlinedColor;
  final bool? obscureText;
  final Color focusedColor;
  final double height;
  final double width;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap;

  const CustomSearch(
      {super.key,
      required this.hintText,
      required this.outlinedColor,
      this.obscureText,
      required this.focusedColor,
      required this.height,
      required this.width,
      this.keyboardType,
      required this.onChanged,
      this.hintStyle,
      this.controller, this.onTap});

  @override
  State<CustomSearch> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomSearch> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: widget.outlinedColor,
              width: 1.8,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(
            Icons.list,
            color: Colors.grey,
          ),
          suffixIcon:Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 6.0, vertical: 6),
            child: GestureDetector(
              onTap: widget.onTap,
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white, // Icon color
                  size: 20,
                ),
              ),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: widget.focusedColor,
              width: 1.8,
            ),
          ),
        ),
      ),
    );
  }
}

