import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/view_model/attributes/attr_author_view_model.dart';
import 'package:library_management_sys/view_model/books/book_view_model.dart';
import 'package:provider/provider.dart';
import '../../resource/colors.dart';

class SearchableAuthorDropdown extends StatefulWidget {
  final String label;
  final double maxWidth;
  final TextEditingController? controller;
  final Function(String?) onChanged;

  const SearchableAuthorDropdown({
    super.key,
    required this.label,
    required this.maxWidth,
    this.controller,
    required this.onChanged,
  });

  @override
  State<SearchableAuthorDropdown> createState() => _SearchableAuthorDropdownState();
}

class _SearchableAuthorDropdownState extends State<SearchableAuthorDropdown> {
  String? selectedAuthor;
  bool isLoad = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isDropdownVisible = false;

  Future<void> fetch() async {
    try {
      await Provider.of<AttrAuthorViewModel>(context, listen: false)
          .fetchAuthorsList(context);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading Authors: $e");
      }
    } finally {
      setState(() => isLoad = false);
    }
  }

  @override
  void initState() {
    super.initState();
    final authorViewModel = Provider.of<AttrAuthorViewModel>(context, listen: false);
    if (authorViewModel.searchValue.isNotEmpty) {
      _searchController.text = authorViewModel.searchValue;
      _isDropdownVisible = true;
    }
    fetch();
    _searchController.addListener(() async {
      final searchText = _searchController.text;
      final genreViewModel = Provider.of<AttrAuthorViewModel>(context, listen: false);
      genreViewModel.setFilter(searchText, context);
      await genreViewModel.fetchAuthorsList(context);
      setState(() {
        _isDropdownVisible = searchText.isNotEmpty;
        if (searchText.isEmpty && selectedAuthor == null) {
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
    final authorViewModel = context.watch<AttrAuthorViewModel>();
    final authors = authorViewModel.authorsList;

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
                  hintText: 'Search Authors...',
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
                    onPressed: () async{
                      _searchController.clear();
                      Provider.of<BooksViewModel>(context, listen: false)
                          .setBookAuthor('', context);
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
                  maxHeight: constraints.maxHeight * 0.4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: authorViewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : authors.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No authors available'),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  itemCount: authors.length,
                  itemBuilder: (context, index) {
                    final author = authors[index];
                    return ListTile(
                      title: Text(
                        author.fullName ?? '',
                        style: TextStyle(fontSize: 14 * fontScale),
                      ),
                      onTap: () {
                        setState(() {
                          selectedAuthor = author.authorId;
                          _isDropdownVisible = false;
                          _searchController.text = author.fullName ?? '';
                          _searchFocusNode.unfocus();
                        });
                        widget.controller?.text = author.authorId ?? '';
                        widget.onChanged(author.authorId);
                      },
                    );
                  },
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
