import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/screens/student/book_info/review.dart';
import 'package:library_management_sys/view_model/books/book_view_model.dart';
import 'package:library_management_sys/widgets/book/book_info_column.dart';
import 'package:library_management_sys/widgets/book/book_info_row.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../resource/colors.dart';

class BookInfo extends StatefulWidget {
  final String uid,
      bookName,
      author,
      subTitle,
      edition,
      year,
      publisher,
      pages,
      bookNo,
      classNo,
      series,
      genre,
      isbn,
      image,
      status;
  const BookInfo(
      {super.key,
      required this.bookName,
      required this.author,
      required this.edition,
      required this.year,
      required this.publisher,
      required this.pages,
      required this.bookNo,
      required this.classNo,
      required this.series,
      required this.genre,
      required this.isbn,
      required this.image,
      required this.status,
      required this.subTitle,
      required this.uid});

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIndividualData();
  }
  bool isLoading = false;

  void getIndividualData() async {
    await Provider.of<BooksViewModel>(context, listen: false)
        .getIndividualBooks(widget.uid, context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return   Scaffold(
      appBar: AppBar(
        title: const Text(
          "Book Info",
          style: TextStyle(fontFamily: 'poppins-black', color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 18,
        ),
        actions: const [
          Image(
            image: AssetImage('assets/images/pcpsLogo.png'),
            width: 56,
            height: 24,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 18,
          )
        ],
      ),
      body: isLoading ? Center(
        child: LoadingAnimationWidget.twistingDots(
          leftDotColor: Colors.red,
          rightDotColor: AppColors.primary,
          size: 40,
        ),
      ): SafeArea(
          child: Container(
        padding: const EdgeInsets.all(20),
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 290,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(8), // Apply border radius here
                      child: CachedNetworkImage(
                        imageUrl: widget.image,
                        width: 200,
                        height: 290,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                widget.bookName,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.orange,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.orange,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.orange,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    '5.0',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.author,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BookInfoColumn(
                          title: 'Edition',
                          value: widget.edition,
                        ),
                        BookInfoColumn(
                          title: 'Publication Year',
                          value: widget.year,
                        ),
                        BookInfoColumn(
                          title: 'Pages',
                          value: widget.pages,
                        )
                      ],
                    )),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: BookInfoRow(
                              title: 'Title',
                              value: widget.bookName,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: BookInfoRow(
                                title: 'Sub Title', value: widget.subTitle),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: BookInfoRow(
                              title: 'Book Number',
                              value: widget.bookNo,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: BookInfoRow(
                              title: 'Class Number',
                              value: widget.classNo,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: BookInfoRow(
                              title: 'Series',
                              value: widget.series,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: BookInfoRow(
                              title: 'Publication',
                              value: widget.publisher,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: BookInfoRow(
                              title: 'Publication Date',
                              value: widget.year,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: BookInfoRow(
                              title: 'Genre',
                              value: widget.genre,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: BookInfoRow(
                              title: 'ISBN',
                              value: widget.isbn,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Consumer<BooksViewModel>(
                        builder: (context, viewModel, child) {
                          if (viewModel.booksData.status == Status.LOADING) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          // Ensure currentUser is not null before using it
                          final user = viewModel.currentUser;
                          if (user == null) {
                            return const Center(child: Text("User data not available"));
                          }

                          String totalBooks = user.total.toString() ?? 'N/A';
                          String available = (user.available != null && user.available != 0)
                              ? "${user.available} available"
                              : "All Reserved";

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: BookInfoRow(
                                      title: 'Total Copies',
                                      value: totalBooks,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    child: const Text(
                                      "Availability",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  buildFilterButton(available, () {}, Colors.green, 12)
                                ],
                              )
                            ],
                          );
                        },
                      ),

                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildFilterButton("Reserve Book", () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              final check =await Provider.of<BooksViewModel>(context,
                                      listen: false)
                                  .reserve(widget.uid, context);
                              if( check){
                               await Provider.of<BooksViewModel>(context,
                                    listen: false)
                                    .getIndividualBooks(widget.uid, context);
                              }
                              setState(() {
                                isLoading = false;
                              });
                            } catch (e) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }, AppColors.primary, 13),
                          const SizedBox(width: 10),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          buildFilterButton("Rate Now", () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        AddReview(
                                  uid: widget.uid,
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));
                                  var offsetAnimation = animation.drive(tween);
                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          }, Colors.red, 13),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget buildFilterButton(
      String title, VoidCallback onTap, Color color, double size) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: size),
        ),
      ),
    );
  }
}
