import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/constant/base_url.dart';
import 'package:library_management_sys/screens/student/book_info/book_info.dart';
import 'package:library_management_sys/widgets/book/book_skeleton.dart';
import 'package:library_management_sys/widgets/dropdowns/custom_authors.dart';
import 'package:library_management_sys/widgets/dropdowns/custom_publisher.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../view_model/books/book_view_model.dart';
import '../../../widgets/custom_search.dart';
import '../../../widgets/dropdowns/custom_genres.dart';
import '../../../resource/colors.dart';
import '../../../widgets/book/book_widget.dart';
import '../../../widgets/explore/explore_header.dart';

class StudentBrowseBooks extends StatefulWidget {
  const StudentBrowseBooks({super.key});

  @override
  State<StudentBrowseBooks> createState() => _BrowseBooksState();
}

class _BrowseBooksState extends State<StudentBrowseBooks> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int index = 0;
  late ScrollController _scrollController;
  bool isLoad = false;
  String message = '';
  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      loadMore();
    }
    if (_scrollController.offset <=
            _scrollController.position.minScrollExtent &&
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
      await Provider.of<BooksViewModel>(context, listen: false)
          .loadMoreBooks(context);
      setState(() {
        isLoad = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error loading more books: $e");
      }
      setState(() {
        isLoad = false;
      });
    }
  }

  resetBooks() async {
    await Provider.of<BooksViewModel>(context, listen: false)
        .resetBookList(context);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/pcpsLogo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Filter By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomGenres(
                label: 'Filter by Genre',
                wid: size.width,
                onChanged: (value) {
                  Provider.of<BooksViewModel>(context, listen: false)
                      .setBookGenreGrp(value!, context);
                  _scaffoldKey.currentState?.closeDrawer();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomAuthor(
                label: 'Filter by Author',
                wid: size.width,
                onChanged: (value) {
                  Provider.of<BooksViewModel>(context, listen: false)
                      .setBookAuthor(value!, context);
                  _scaffoldKey.currentState?.closeDrawer();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomPublisher(
                label: 'Filter by Publisher',
                wid: size.width,
                onChanged: (value) {
                  Provider.of<BooksViewModel>(context, listen: false)
                      .setPublisher(value!, context);
                  _scaffoldKey.currentState?.closeDrawer();
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: size.width,
          child: Column(
            children: [
              const ExploreHeader(),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Browse books based on your interests',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      buildFilterButton("All Books", () {
                        setState(() {
                          index = 0;
                        });
                        resetBooks();
                      }, 0),
                      const SizedBox(width: 8),
                      buildFilterButton("Top Rated", () {
                        setState(() {
                          index = 1;
                        });
                      }, 1),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.0,
                        ),
                      ),
                      child: const Icon(
                        Icons.filter_alt_rounded,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Consumer<BooksViewModel>(
                builder: (context, viewModel, child) {
                  final TextEditingController _controller =
                      TextEditingController(text: viewModel.searchValue);
                  return CustomSearch(
                    controller: _controller,
                    hintText: 'Search Books',
                    outlinedColor: Colors.grey,
                    focusedColor: AppColors.primary,
                    height: 50,
                    width: double.infinity,
                    onChanged: (e) {},
                    onTap: () {
                      String searchValue = _controller.text;
                      viewModel.setFilter(searchValue, context);
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

                    return Consumer<BooksViewModel>(
                      builder: (context, value, child) {
                        final books = value.booksList;

                        if (value.isLoading) {
                          return const BookSkeletonGrid();
                        }

                        if (books.isEmpty) {
                          return const Center(
                            child: Text(
                              'No Books available.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.only(bottom: 18),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15,
                            childAspectRatio: aspectRatio,
                          ),
                          itemCount: books.length + (isLoad ? 1 : 0),
                          physics: const BouncingScrollPhysics(),
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            if (index == books.length) {
                              return Center(
                                child: LoadingAnimationWidget.twistingDots(
                                  leftDotColor: Colors.red,
                                  rightDotColor: AppColors.primary,
                                  size: 40,
                                ),
                              );
                            }
                            final book = books[index];
                            // if (kDebugMode) {
                            //   print(
                            //       "Image display : ${BaseUrl.imageDisplay}/${book.coverPhoto ?? ''}");
                            // }
                            String authors = "By ";
                            List<String> authorNames =
                                book.bookAuthors.map((bookAuthor) {
                              return bookAuthor.author.fullName ?? '';
                            }).toList();
                            authors += authorNames.join(", ");
                            int score =0;

                            String genres = "";
                            List<String> genresMap =
                                book.bookGenres.map((bookGenres) {
                              return bookGenres.genre.genre ?? '';
                            }).toList();
                            genres += genresMap.join(", ");

                            String isbn = "";
                            List<String> isbnMap = book.isbns.map((isbn) {
                              return isbn.isbn ?? '';
                            }).toList();
                            isbn += isbnMap.join(", ");
                            return BookWidget(
                                bookImage:
                                    "${BaseUrl.imageDisplay}/${book.coverPhoto ?? ''}",
                                title: book.title ?? '',
                                author:
                                    "By ${book.bookAuthors[0].author.fullName}" ??
                                        '',
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => BookInfo(
                                          uid: book.bookInfoId ?? '',
                                          bookName: book.title ?? '',
                                          author: authors??'',
                                          edition: book.editionStatement ?? '',
                                          year:
                                              book.publicationYear.toString() ??
                                                  '',
                                          publisher:
                                              book.publisher.publisherName ??
                                                  '',
                                          pages:
                                              book.numberOfPages.toString() ??
                                                  '',
                                          bookNo:
                                              book.bookNumber.toString() ?? '',
                                          classNo:
                                              book.classNumber.toString() ?? '',
                                          series:
                                              book.seriesStatement.toString() ??
                                                  '',
                                          genre: genres??'',
                                          isbn: isbn??'',
                                          image: "${BaseUrl.imageDisplay}/${book.coverPhoto}" ?? '',
                                          status: '',
                                          subTitle: book.subTitle??''),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;
                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));
                                        var offsetAnimation =
                                            animation.drive(tween);
                                        return SlideTransition(
                                          position: offsetAnimation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                });
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

  Widget buildFilterButton(String title, VoidCallback onTap, int tabIndex) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: index == tabIndex ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.primary, width: 1.0),
        ),
        child: Text(
          title,
          style: TextStyle(
              color: index == tabIndex ? Colors.white : AppColors.primary,
              fontSize: 12),
        ),
      ),
    );
  }
}
