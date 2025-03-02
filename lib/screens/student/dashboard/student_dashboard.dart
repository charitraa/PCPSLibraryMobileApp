import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/colors.dart';
import 'package:library_management_sys/view_model/attributes/attr_author_view_model.dart';
import 'package:library_management_sys/view_model/attributes/attr_genre_view_model.dart';
import 'package:library_management_sys/view_model/attributes/attr_publisher_view_model.dart';
import 'package:library_management_sys/widgets/book/book_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../constant/base_url.dart';
import '../../../view_model/books/book_view_model.dart';
import '../../../widgets/book/book_skeleton.dart';
import '../book_info/book_info.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBooks();
  }
  fetchBooks() async {
    await Provider.of<BooksViewModel>(context, listen: false)
        .fetchBooksList(context);
    await Provider.of<AttrPublisherViewModel>(context, listen: false)
        .fetchPublishersList(context);
    await Provider.of<AttrGenreViewModel>(context, listen: false)
        .fetchGenresList(context);
    await Provider.of<AttrAuthorViewModel>(context, listen: false)
        .fetchAuthorsList(context);
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
             const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        foregroundImage: AssetImage('assets/images/one.webp'),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "WELCOME",
                            style: TextStyle(
                                color: AppColors.secondary, letterSpacing: 1.2),
                          ),
                          Text(
                            "Minal Pariyar",
                            style: TextStyle(
                                color: AppColors.secondary,
                                fontFamily: 'poppins-black'),
                          )
                        ],
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Icon(Icons.notifications),
                      SizedBox(
                        width: 4,
                      ),
                      Image(
                        image: AssetImage('assets/images/pcpsLogo.png'),
                        width: 60,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12,),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  "Explore",
                  style: TextStyle(
                      fontSize: 43,
                      color: AppColors.primary,
                      fontFamily: 'poppins-black'),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Most Popular',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'poppins-black',
                        color: AppColors.primary),
                  ),

                ],
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 200,
                child: Consumer<BooksViewModel>(
                  builder: (context, value, child) {
                    final books = value.booksList;

                    if (value.isLoading) {
                      return const BookSkeletonGrid();
                    }

                    if (books.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Books available.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(bottom: 18),
                      itemCount: 6,

                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {

                        final book = books[index];
                        if (kDebugMode) {
                          print("${BaseUrl.imageDisplay}/${book.coverPhoto ?? ''}");
                        }
                        String authors = "By ";
                        List<String> authorNames =
                        book.bookAuthors.map((bookAuthor) {
                          return bookAuthor.author.fullName ?? '';
                        }).toList();
                        authors += authorNames.join(", ");
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: BookWidget(
                            bookImage: "${BaseUrl.imageDisplay}/${book.coverPhoto ?? ''}",
                            title: book.title ?? '',
                            author: "By ${book.bookAuthors[0].author.fullName}"??'',
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
                              }
                          ),
                        );
                      },
                    );
                  },
                ),
              )
             ,
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'E-library',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'poppins-black',
                        color: AppColors.primary),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Icon(Icons.arrow_forward_ios_sharp,
                        size: 18, color: AppColors.primary),
                  )
                ],
              ),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    BookWidget(
                        bookImage: 'assets/images/book.png',
                        title: "My Type of book and well done",
                        author: "Author kenzie Mcnary"),
                    SizedBox(
                      width: 8,
                    ),
                    BookWidget(
                        bookImage: 'assets/images/two.webp',
                        title: "A Million To One",
                        author: "Tony Fagoli"),
                    SizedBox(
                      width: 8,
                    ),
                    BookWidget(
                        bookImage: 'assets/images/hide.webp',
                        title: "Hide and Seek",
                        author: "Olivia Wilson"),
                    SizedBox(
                      width: 8,
                    ),
                    BookWidget(
                        bookImage: 'assets/images/one.webp',
                        title: "Walk Into The shadow",
                        author: "Author kenzie Mcnary"),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
