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
      await Provider.of<AttrGenreViewModel>(context, listen: false)
          .loadMoreGenres(context);
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
      context.read<AttrGenreViewModel>().fetchGenresList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final genreViewModel = context.watch<AttrGenreViewModel>();
    final genres = genreViewModel.GenresList;

    if (genres.isEmpty) {
      return const Center(child: Text('No genres available'));
    }

    String? initialValue = selectedRegion ??
        (widget.controller?.text.isNotEmpty == true &&
            genres.any((h) => h.genreId == widget.controller?.text)
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
          child: genreViewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : genres.isEmpty
              ? const Center(child: Text('No genres available'))
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
            hint: const Text('Select a genre'),
            items: genres.map((genres) {
              return DropdownMenuItem<String>(
                value: genres.genreId,
                child: Text(
                  genres.genre.split(' ').take(3).join(' ') +
                      ( genres.genre.split(' ').length > 2
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
