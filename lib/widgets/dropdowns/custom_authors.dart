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
  late ScrollController _scrollController;
  bool isLoad = false;
  String message = '';
  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      loadMore();
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        message = "Reached the top";
      });
    }
  }
  loadMore() async {
    setState(() {
      isLoad = true;
    });
    try {
      await Provider.of<AttrAuthorViewModel>(context, listen: false)
          .loadMoreAuthors(context);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading more books: $e");
      }
    } finally {
      setState(() {
        isLoad = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AttrAuthorViewModel>().fetchAuthorsList(context);
    });
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
            fontFamily: 'poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(0),
          width: widget.wid,
          child: authorViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : authors.isEmpty
              ? const Center(child: Text('No authors available'))
              : DropdownButtonFormField<String>(
            decoration: InputDecoration(
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(width: 1.5, color: AppColors.primary),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
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
            items: authors.map((authors) {
              return DropdownMenuItem<String>(
                value: authors.authorId,
                child: Text(
                  authors.fullName.split(' ').take(3).join(' ') +
                      ( authors.fullName.split(' ').length > 2
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
          ),
        ),
      ],
    );
  }
}
