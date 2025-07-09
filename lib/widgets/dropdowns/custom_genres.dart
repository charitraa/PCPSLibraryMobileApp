import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/view_model/attributes/attr_genre_view_model.dart';
import 'package:library_management_sys/view_model/books/book_view_model.dart';
import 'package:provider/provider.dart';
import '../../resource/colors.dart';

class SearchableGenreDropdown extends StatefulWidget {
  final String label;
  final double maxWidth;
  final TextEditingController? controller;
  final Function(String?) onChanged;

  const SearchableGenreDropdown({
    super.key,
    required this.label,
    required this.maxWidth,
    this.controller,
    required this.onChanged,
  });

  @override
  State<SearchableGenreDropdown> createState() => _SearchableGenreDropdownState();
}

class _SearchableGenreDropdownState extends State<SearchableGenreDropdown> {
  String? selectedGenre;
  bool isLoad = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isDropdownVisible = false;

  Future<void> fetch() async {
    try {
      setState(() => isLoad = true);
      await Provider.of<AttrGenreViewModel>(context, listen: false)
          .fetchGenresList(context);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading genres: $e");
      }
    } finally {
      setState(() => isLoad = false);
    }
  }

  @override
  void initState() {
    super.initState();
    final genreViewModel = Provider.of<AttrGenreViewModel>(context, listen: false);

    if (genreViewModel.searchValue.isNotEmpty) {
      _searchController.text = genreViewModel.searchValue;
      _isDropdownVisible = true;
    }

    fetch();

    _searchController.addListener(() async {
      final searchText = _searchController.text;
      final genreViewModel = Provider.of<AttrGenreViewModel>(context, listen: false);

      genreViewModel.setFilter(searchText, context);
      await genreViewModel.fetchGenresList(context);

      setState(() {
        _isDropdownVisible = searchText.isNotEmpty;
        if (searchText.isEmpty && selectedGenre == null) {
          widget.controller?.clear();
          widget.onChanged(null);
        }
      });
    });

    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        setState(() => _isDropdownVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final genreViewModel = context.watch<AttrGenreViewModel>();
    final genres = genreViewModel.genresList;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double containerWidth =
        constraints.maxWidth > widget.maxWidth ? widget.maxWidth : constraints.maxWidth;
        final double fontScale = constraints.maxWidth < 400 ? 0.9 : 1.0;
        final double paddingScale = constraints.maxWidth < 400 ? 4.0 : 8.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 14 * fontScale,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: paddingScale),
            // Search TextField
            Container(
              width: containerWidth,
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search genres...',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: paddingScale * 2,
                    vertical: paddingScale,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: AppColors.primary),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.5, color: AppColors.primary),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _isDropdownVisible = false;
                        selectedGenre = null;
                      });
                      Provider.of<BooksViewModel>(context, listen: false)
                          .setBookGenreGrp('', context);
                      widget.controller?.clear();
                      widget.onChanged(null);
                    },
                  )
                      : null,
                ),
              ),
            ),
            SizedBox(height: paddingScale),
            // Search Results List
            if (_isDropdownVisible)
              Container(
                width: containerWidth,
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight * 0.4, // Limit height to 40% of available space
                  minHeight: 50.0, // Ensure minimum height for visibility
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: genreViewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : genres.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No genres available'),
                )
                    : Scrollbar(
                  thumbVisibility: true, // Show scrollbar thumb
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(), // Smooth scrolling
                    itemCount: genres.length,
                    itemBuilder: (context, index) {
                      final genre = genres[index];
                      return ListTile(
                        title: Text(
                          genre.genre ?? '',
                          style: TextStyle(fontSize: 14 * fontScale),
                        ),
                        onTap: () {
                          setState(() {
                            selectedGenre = genre.genreId;
                            _isDropdownVisible = false;
                            _searchController.text = genre.genre ?? '';
                            _searchFocusNode.unfocus();
                          });
                          widget.controller?.text = genre.genreId ?? '';
                          widget.onChanged(genre.genreId);
                        },
                      );
                    },
                  ),
                ),
              ),
            if (isLoad && _isDropdownVisible)
              Padding(
                padding: EdgeInsets.symmetric(vertical: paddingScale),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}