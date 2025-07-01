import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/view_model/attributes/attr_publisher_view_model.dart';
import 'package:provider/provider.dart';

import '../../resource/colors.dart';
import '../../view_model/books/book_view_model.dart';

class SearchablePublisherDropdown extends StatefulWidget {
  final String label;
  final double maxWidth;
  final TextEditingController? controller;
  final Function(String?) onChanged;

  const SearchablePublisherDropdown({
    super.key,
    required this.label,
    required this.maxWidth,
    this.controller,
    required this.onChanged,
  });

  @override
  State<SearchablePublisherDropdown> createState() => _SearchablePublisherDropdownState();
}

class _SearchablePublisherDropdownState extends State<SearchablePublisherDropdown> {
  String? selectedPublisher;
  bool isLoad = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isDropdownVisible = false;

  Future<void> fetch() async {
    try {
      await Provider.of<AttrPublisherViewModel>(context, listen: false)
          .fetchPublishersList(context);
    } catch (e) {
      if (kDebugMode) print("Error loading publishers: $e");
    } finally {
      setState(() => isLoad = false);
    }
  }

  @override
  void initState() {
    super.initState();
    final publisherViewModel = Provider.of<AttrPublisherViewModel>(context, listen: false);
    if (publisherViewModel.searchValue.isNotEmpty) {
      _searchController.text = publisherViewModel.searchValue;
      _isDropdownVisible = true;
    }
    fetch();
    _searchController.addListener(() {
      final searchText = _searchController.text;
      Provider.of<AttrPublisherViewModel>(context, listen: false)
          .setFilter(searchText, context);
      setState(() {
        _isDropdownVisible = searchText.isNotEmpty;
        if (searchText.isEmpty && selectedPublisher == null) {
          if (widget.controller != null) {
            widget.controller!.clear();
          }
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
    final publisherViewModel = context.watch<AttrPublisherViewModel>();
    final publishers = publisherViewModel.publishersList;

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
            // Search Field
            Container(
              width: containerWidth,
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search publishers...',
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
                    onPressed: () async {
                      _searchController.clear();
                      Provider.of<BooksViewModel>(context, listen: false)
                          .setPublisher('', context);
                      setState(() {
                        selectedPublisher = null;
                        _isDropdownVisible = true;
                        _searchFocusNode.unfocus();
                      });
                      if (widget.controller != null) {
                        widget.controller!.clear();
                      }
                      widget.onChanged(null);
                    },
                  )
                      : null,
                ),
              ),
            ),
            SizedBox(height: paddingScale),
            // Dropdown Results
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
                child: publisherViewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : publishers.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No publishers available'),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  itemCount: publishers.length,
                  itemBuilder: (context, index) {
                    final publisher = publishers[index];
                    return ListTile(
                      title: Text(
                        publisher.publisherName ?? '',
                        style: TextStyle(fontSize: 14 * fontScale),
                      ),
                      onTap: () {
                        setState(() {
                          selectedPublisher = publisher.publisherId;
                          _isDropdownVisible = false;
                          _searchController.text = publisher.publisherName ?? '';
                          _searchFocusNode.unfocus();
                        });
                        if (widget.controller != null) {
                          widget.controller!.text = publisher.publisherId!;
                        }
                        widget.onChanged(publisher.publisherId);
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
