import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/view_model/attributes/attr_genre_view_model.dart';
import 'package:provider/provider.dart';

import '../../resource/colors.dart';

class CustomGenres extends StatefulWidget {
  final String label;
  final double wid;
  final TextEditingController? controller;
  final Function(String?) onChanged;

  const CustomGenres({
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
  State<CustomGenres> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<CustomGenres> {
  String? selectedGenre;
  bool isLoad = false;

  Future<void> loadMore() async {
    if (isLoad) return; // Prevent multiple requests
    setState(() => isLoad = true);

    try {
      await Provider.of<AttrGenreViewModel>(context, listen: false)
          .loadMoreGenres(context);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading more genres: $e");
      }
    } finally {
      setState(() => isLoad = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final genreViewModel = context.watch<AttrGenreViewModel>();
    final genres = genreViewModel.genresList;

    if (genres.isEmpty) {
      return const Center(child: Text('No genres available'));
    }

    String? initialValue = selectedGenre ??
        (widget.controller?.text.isNotEmpty == true &&
            genres.any((g) => g.genreId == widget.controller?.text)
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
          child: genreViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : genres.isEmpty
              ? const Center(child: Text('No genres available'))
              : DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                      !isLoad) {
                    loadMore(); // Load more genres when scrolled to the bottom
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
                  hint: const Text('Select a genre'),
                  items: genres.map((genre) {
                    return DropdownMenuItem<String>(
                      value: genre.genreId,
                      child: Text(
                        genre.genre!.split(' ').take(3).join(' ') +
                            (genre.genre!.split(' ').length > 2
                                ? '...'
                                : ''),
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGenre = newValue;
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
