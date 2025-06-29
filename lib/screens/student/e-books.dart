import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/constant/base_url.dart';
import 'package:library_management_sys/resource/colors.dart';
import 'package:library_management_sys/view_model/books/online_books_view_model.dart';
import 'package:library_management_sys/widgets/book/book_skeleton.dart';
import 'package:library_management_sys/widgets/book/online_book_wid.dart';
import 'package:library_management_sys/widgets/custom_search.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/explore/explore_header.dart';

class Ebooks extends StatefulWidget {
  const Ebooks({super.key});

  @override
  State<Ebooks> createState() => _EbooksState();
}

class _EbooksState extends State<Ebooks> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  bool isLoadMore = false;
  String message = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _scrollController.addListener(_scrollListener);
    _fetchBooks();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMore();
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        message = "Reached the top";
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      isLoadMore = true;
    });
    try {
      await Provider.of<OnlineBooksViewModel>(context, listen: false)
          .loadMoreBooks(context);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading more books: $e");
      }
    } finally {
      setState(() {
        isLoadMore = false;
      });
    }
  }

  Future<void> _fetchBooks() async {
    final booksViewModel = Provider.of<OnlineBooksViewModel>(context, listen: false);
    await booksViewModel.fetchBooksList(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchBookUrl(String? bookUrl) async {
    if (bookUrl == null || bookUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No URL available for this book')),
      );
      return;
    }

    final Uri url = Uri.parse(bookUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the book URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ExploreHeader(text: 'E-Books',),
              const SizedBox(height: 5),
              Text(
                'Explore online books to read anytime, anywhere',
                style: TextStyle(color: AppColors.primary),
              ),
              const SizedBox(height: 10),
              Consumer<OnlineBooksViewModel>(
                builder: (context, viewModel, child) {
                  _searchController.text = viewModel.searchValue; // Sync with view model
                  return CustomSearch(
                    onReset: (){
                      viewModel.resetBookList(context);
                    },
                    controller: _searchController,
                    hintText: 'Search Books',
                    outlinedColor: Colors.grey,
                    focusedColor: AppColors.primary,
                    height: 50,
                    width: double.infinity,
                    onChanged: (value) {

                    },
                    onTap: () {
                      viewModel.setFilter(_searchController.text, context);
                    },
                  );
                },
              ),
              const SizedBox(height: 15),
              Flexible(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double itemWidth = (constraints.maxWidth - (10 * 2)) / 3;
                    double itemHeight = 180;
                    double aspectRatio = itemWidth / itemHeight;

                    return Consumer<OnlineBooksViewModel>(
                      builder: (context, value, child) {
                        final books = value.booksList;

                        if (value.isLoading && books.isEmpty) {
                          return const BookSkeletonGrid();
                        }

                        if (books.isEmpty) {
                          return _buildNoDataCard(size,'Oops! No online books have been added yet!');
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.only(bottom: 18),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15,
                            childAspectRatio: aspectRatio,
                          ),
                          itemCount: books.length + (isLoadMore ? 1 : 0),
                          physics: const BouncingScrollPhysics(),
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            if (index == books.length) {
                              return _buildLoadMoreSkeleton();
                            }
                            final book = books[index];

                            String? profileImageUrl;
                            try {
                              profileImageUrl = book.coverPhoto;
                            } catch (e) {
                              profileImageUrl = '';
                            }
                            return OnlineBookWid(
                              bookImage:
                              "${BaseUrl.imageDisplay}/${profileImageUrl ?? ''}",
                              title: book.title ?? '',
                              onTap: () {
                                _launchBookUrl(book.resourceUrl); // Launch book URL
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadMoreSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        height: 150,
        width: 100,
      ),
    );
  }
  Widget _buildNoDataCard(Size size, String message) {
    return Container(
      width: size.width * 0.9,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey[400]!, width: 0.5),
      ),
      alignment: Alignment.center,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.disabled_visible_rounded,),
          const SizedBox(height: 5,),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

}