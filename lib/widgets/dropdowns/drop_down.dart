import 'package:flutter/material.dart';

import '../../resource/colors.dart';

class CustomGenre extends StatefulWidget {
  final String label;
  final double wid;
  final TextEditingController? controller;
  final Function(String?) onChanged;

  const CustomGenre({
    super.key,
    required this.label,
    required this.wid,
    this.controller,
    required this.onChanged,
  });

  final border = const OutlineInputBorder(
    borderSide: BorderSide(
      width: 1.5,
      color: Colors.grey,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    ),
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );

  @override
  State<CustomGenre> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<CustomGenre> {
  final List<String> items = ['Horror', 'Comedy'];
  String? selectedRegion;

  @override
  void initState() {
    super.initState();
    selectedRegion = widget.controller?.text.isNotEmpty == true &&
        items.contains(widget.controller?.text)
        ? widget.controller?.text
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(0),
          width: widget.wid,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              fillColor: Colors.white,
              enabledBorder: widget.border,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color: AppColors.primary,
                  style: BorderStyle.solid,
                  strokeAlign: BorderSide.strokeAlignCenter,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
            ),
            value: selectedRegion,
            hint: const Text('Select Genre'),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedRegion = newValue;
              });

              if (widget.controller != null) {
                widget.controller!.text = newValue ?? '';
              }
              widget.onChanged(newValue);
            },
          ),
        ),
      ],
    );
  }
}
