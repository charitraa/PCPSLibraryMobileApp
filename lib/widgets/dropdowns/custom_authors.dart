import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/view_model/attributes/attr_author_view_model.dart';
import 'package:provider/provider.dart';

import '../../resource/colors.dart';

class CustomAuthor extends StatefulWidget {
  final String label;
  final double wid;
  final TextEditingController? controller;
  final Function(String?) onChanged;

  const CustomAuthor({
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
  State<CustomAuthor> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<CustomAuthor> {
  String? selectedRegion;
  bool isLoad = false;



  Future<void> loadMore() async {
    if (isLoad) return;
    setState(() => isLoad = true);

    try {
      await Provider.of<AttrAuthorViewModel>(context, listen: false)
          .loadMoreAuthors(context);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading more authors: $e");
      }
    } finally {
      setState(() => isLoad = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authorViewModel = context.watch<AttrAuthorViewModel>();
    final authors = authorViewModel.authorsList;

    if (authors.isEmpty) {
      return const Center(child: Text('No Authors available'));
    }

    String? initialValue = selectedRegion ??
        (widget.controller?.text.isNotEmpty == true &&
            authors.any((h) => h.authorId == widget.controller?.text)
            ? widget.controller?.text
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: widget.wid,
          child: authorViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : authors.isEmpty
              ? const Center(child: Text('No authors available'))
              : DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                      !isLoad) {
                    loadMore(); // Load more authors when scrolled to the bottom
                  }
                  return false;
                },
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 1.5, color: AppColors.primary),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: AppColors.primary,
                      ),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  value: initialValue,
                  hint: const Text('Select an author'),
                  items: authors.map((author) {
                    return DropdownMenuItem<String>(
                      value: author.authorId,
                      child: Text(
                        author.fullName!.split(' ').take(3).join(' ') +
                            (author.fullName!.split(' ').length > 2
                                ? '...'
                                : ''),
                        style: const TextStyle(fontSize: 14),
                      ),
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
                  menuMaxHeight: 300, // Ensure dropdown is scrollable
                  dropdownColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
        if (isLoad)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
