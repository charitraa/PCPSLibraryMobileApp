import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/colors.dart';
import 'package:library_management_sys/screens/student/in_app_notification/in_app_notification.dart';
import 'package:library_management_sys/view_model/attributes/attr_author_view_model.dart';
import 'package:library_management_sys/view_model/attributes/attr_genre_view_model.dart';
import 'package:library_management_sys/view_model/attributes/attr_publisher_view_model.dart';
import 'package:library_management_sys/view_model/auth_view_model.dart';
import 'package:library_management_sys/view_model/notifications/notification_view_model.dart';
import 'package:library_management_sys/widgets/book/book_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../constant/base_url.dart';
import '../../../data/response/status.dart';
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
    await Provider.of<NotificationViewModel>(context, listen: false)
        .fetchNotifications(context);
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
              const SizedBox(
                height: 10,
              ),
              Consumer<AuthViewModel>(
                builder: (context, userDataViewModel, child) {
                  final user = userDataViewModel.currentUser;
                  if (userDataViewModel.userData.status == Status.ERROR) {
                    return const Text(
                      "Something went wrong",
                      style: TextStyle(color: Colors.red),
                    );
                  } else if (user != null) {
                    String getFirstWord(String input) {
                      List<String> words = input.trim().split(' ');
                      return words.isNotEmpty ? words[0] : input;
                    }

                    String name = getFirstWord(user.fullName!);
                    String image = user.profilePicUrl != null
                        ? "${BaseUrl.imageDisplay}/${user.profilePicUrl}"
                        : '';
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey[300],
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: image,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error, size: 24),
                                ),
                              ),
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
                                      color: AppColors.secondary,
                                      letterSpacing: 1.2),
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 12,
                                      fontFamily: 'poppins-black'),
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) =>
                                        NotificationPage(),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;
                                      var tween = Tween(begin: begin, end: end)
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
                              },
                              child: Consumer<NotificationViewModel>(
                                builder:
                                    (context, notificationViewModel, child) {
                                  int unreadCount = notificationViewModel
                                      .notificationList
                                      .where((notification) =>
                                  !(notification.read ?? false))
                                      .length;
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      const Icon(Icons.notifications,
                                          size: 28),
                                      if (unreadCount > 0)
                                        Positioned(
                                          right: 0,
                                          top: -5,
                                          child: Container(
                                            padding: const EdgeInsets.all(
                                                4), // Adjust padding for better spacing
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 18,
                                              minHeight: 18,
                                            ),
                                            child: Center(
                                              child: Text(
                                                unreadCount.toString(),
                                                style: const TextStyle(
                                                  color: Colors
                                                      .white, // White text color
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),

                            const SizedBox(
                              width: 4,
                            ),
                            const Image(
                              image: AssetImage('assets/images/pcpsLogo.png'),
                              width: 60,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ],
                        )
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.grey[300],
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: '',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error, size: 24),
                                  ),
                                ),
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
                                        color: AppColors.secondary,
                                        letterSpacing: 1.2),
                                  ),
                                  Text(
                                    'Unknown',
                                    style: TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 12,
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
                    );
                  }
                },
              ),

              const SizedBox(
                height: 12,
              ),
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
              const SizedBox(
                height: 10,
              ),
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

                        String authors = "By ";
                        List<String> authorNames =
                            book.bookAuthors!.map((bookAuthor) {
                          return bookAuthor.author!.fullName ?? '';
                        }).toList();
                        authors += authorNames.join(", ");
                        String genres = "";
                        List<String> genresMap =
                            book.bookGenres!.map((bookGenres) {
                          return bookGenres.genre!.genre ?? '';
                        }).toList();
                        genres += genresMap.join(", ");

                        String isbn = "";
                        List<String> isbnMap = book.isbns!.map((isbn) {
                          return isbn.isbn ?? '';
                        }).toList();
                        isbn += isbnMap.join(", ");
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: BookWidget(
                              bookImage:
                                  "${BaseUrl.imageDisplay}/${book.coverPhoto ?? ''}",
                              title: book.title ?? '',
                              author:
                                  "By ${book.bookAuthors![0].author!.fullName}" ??
                                      '',
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => BookInfo(
                                        uid: book.bookInfoId ?? '',
                                        bookName: book.title ?? '',
                                        author: authors ?? '',
                                        edition: book.editionStatement ?? '',
                                        year: book.publicationYear.toString() ??
                                            '',
                                        publisher:
                                            book.publisher!.publisherName ?? '',
                                        pages:
                                            book.numberOfPages.toString() ?? '',
                                        score: book.score!.isNotEmpty
                                            ? (book.score![0]['score'] as int)
                                                .toDouble()
                                            : 0,
                                        bookNo:
                                            book.bookNumber.toString() ?? '',
                                        classNo:
                                            book.classNumber.toString() ?? '',
                                        series:
                                            book.seriesStatement.toString() ??
                                                '',
                                        genre: genres ?? '',
                                        isbn: isbn ?? '',
                                        image:
                                            "${BaseUrl.imageDisplay}/${book.coverPhoto}" ??
                                                '',
                                        status: '',
                                        subTitle: book.subTitle ?? ''),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;
                                      var tween = Tween(begin: begin, end: end)
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
                              }),
                        );
                      },
                    );
                  },
                ),
              ),
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
              // const SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   padding: EdgeInsets.symmetric(vertical: 10),
              //   child: Row(
              //     children: [
              //       BookWidget(
              //           bookImage: 'assets/images/book.png',
              //           title: "My Type of book and well done",
              //           author: "Author kenzie Mcnary"),
              //       SizedBox(
              //         width: 8,
              //       ),
              //       BookWidget(
              //           bookImage: 'assets/images/two.webp',
              //           title: "A Million To One",
              //           author: "Tony Fagoli"),
              //       SizedBox(
              //         width: 8,
              //       ),
              //       BookWidget(
              //           bookImage: 'assets/images/hide.webp',
              //           title: "Hide and Seek",
              //           author: "Olivia Wilson"),
              //       SizedBox(
              //         width: 8,
              //       ),
              //       BookWidget(
              //           bookImage: 'assets/images/one.webp',
              //           title: "Walk Into The shadow",
              //           author: "Author kenzie Mcnary"),
              //       SizedBox(
              //         width: 8,
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    ));
  }
}
